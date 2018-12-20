//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.displayUpdatedAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    func displayUpdatedAnnotations() {
        
        // Populate the mapView with 100 pins:
        self.MapView.removeAnnotations(MapView.annotations)
        
        // We will create an MKPointAnnotation for each dictionary in "locations".
        var newAnnotations = [MKPointAnnotation]()
        
        
        // This is an array of studentLocations (struct StudentInformation)
        for student in StudentData.sharedInstance.arrayOfStudentLocations {
            
            
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            // we are placing the annotation in an array of annotations.
            newAnnotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.MapView.addAnnotations(newAnnotations)
    }
    
    // removes current annotations and re-inserts annotations
    func updateAnnotations() {
        
        
        var annotations = [MKPointAnnotation]()
        
        for student in StudentData.sharedInstance.arrayOfStudentLocations {
            
            let lat = CLLocationDegrees(student.latitude ?? 0)
            let long = CLLocationDegrees(student.longitude ?? 0)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            //creating the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            // place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.MapView.addAnnotations(annotations)
    }

    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        MapView.setRegion(coordinateRegion, animated: true)
    }
    
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            MapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // MARK: - MKMapViewDelegate
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {
                
                // print: true or false
                print("verifyURL: \(verifyUrl(urlString: url))")
                
                if verifyUrl(urlString: url) == true {
                    app.open(URL(string:url)!)
                } else {
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                }
            }
        }
    }
}
