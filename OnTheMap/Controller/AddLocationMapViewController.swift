//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapImage: MKMapView!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    var newLocation = StudentInformation.NewUserLocation.mapString
    var newURL = StudentInformation.NewUserLocation.mediaURL
    var newLatitude = StudentInformation.NewUserLocation.latitude
    var newLongitude = StudentInformation.NewUserLocation.longitude
    var userObjectId = StudentInformation.UserData.objectId
    
    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            
            //Update the pins (no duplicates)
            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                //Display name and url link
                annotation.title = newLocation
                annotation.subtitle = newURL
                
                mapImage.addAnnotation(annotation)
            }
        }
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapImage.delegate = self
        actIndicator.hidesWhenStopped = true
        
        let location = userNewLocationData()
        
        //Create an MKPointAnnotation for each dictionary in "locations."
        var annotations = [MKPointAnnotation]()
        
        for item in location {
            let lat = CLLocationDegrees(item["latitude"] as! Double)
            let long = CLLocationDegrees(item["longitude"] as! Double)
            
            // Use above to create CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = item["firstName"] as! String
            let last = item["lastName"] as! String
            let mediaURL = item["mediaURL"] as! String
            
            //Create the annotation coordinate with title and subtitle.
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            //Place in array of annotations:
            annotations.append(annotation)
        }
        
        //Mentor: "When the array is complete, we add the annotations to the map. There is only one item in the array: User's new location."
        self.mapImage.addAnnotations(annotations)
        
        let initialLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)
        
        //From an example on forum: Calling the helper method to zoom into 'initialLocation' on startup.
        centerMapOnLocation(location: initialLocation)
    }
    
    
    
    func userNewLocationData() -> [[String : Any]] {
        return [
            [
                "createdAt" : "",
                "firstName" : StudentInformation.UserData.firstName,
                "lastName" : StudentInformation.UserData.lastName,
                "latitude" : StudentInformation.NewUserLocation.latitude,
                "longitude" : StudentInformation.NewUserLocation.longitude,
                "mapString" : StudentInformation.NewUserLocation.mapString,
                "mediaURL" : StudentInformation.NewUserLocation.mediaURL,
                "objectId" : "",
                "uniqueKey" : StudentInformation.UserData.uniqueKey,
                "updatedAt" : ""
            ]
        ]
    }
    
    //Specify the rectangular region to display for correct zoom level.
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapImage.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: MKMapViewDelegate (right callout accessory view).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //Open the system browser to specified URL in subtitle when tapped.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                
                app.open(URL(string: url)!, options: [:], completionHandler: { (success)
                    in
                    if !success {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                })
            }
        } else {
            createAlert(title: "Error", message: "Could not redirect to web browser. Check to see if URL is valid")
        }
    }
    
    

    @IBAction func submitButtonPressed(_ sender: Any) {
        submitButton.isEnabled = false
        actIndicator.startAnimating()
        //Get Student's Data
        if userObjectId.isEmpty {
            callPostToStudentLocation()
            
        } else {
            //User already exists (PUT)
            callPutToStudentLocation()
            
        }
    }
    //MARK: Methods
    func callPostToStudentLocation() {
        ParseClient.sharedInstance().postAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPOST: { (success, errorString) in
            
            guard success else {
                // display the errorString using createAlert
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
            
            ParseClient.sharedInstance().getALocation() { (data, errorString) in
                guard success else {
                    performUIUpdatesOnMain {
                       self.createAlert(title: "Error", message: "Failed to download user location data.")
                    }
                    return
                }
                
                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getLocationsRequest() { (data, errorString) in
                    
                    guard success else {
                        
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Failed to download student locations data.")
                        }
                        return
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
    }
    
    func callPutToStudentLocation() {
        ParseClient.sharedInstance().putAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPUT: { (success, errorString) in
            
            guard success else {
                
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Unable to add new location. The Internet connection appears to be offline.")
                }
                return
            }
            
            ParseClient.sharedInstance().getALocation() { (success, errorString) in
                guard (success == true) else {
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "Failed to download user location data.")
                    }
                    return
                }
                
                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getLocationsRequest() { (data, errorString) in
                    
                    guard success else {
                        
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Failed to download student locations data.")
                        }
                        return
                    }
                
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
        })
    }

}
