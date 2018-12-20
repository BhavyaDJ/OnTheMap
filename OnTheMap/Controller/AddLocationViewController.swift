//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    var keyboardOnScreen = false
    // Variables for new user coordinates passed
    var newLocation = ""
    var newURL = ""
    var newLatitude = 0.0
    var newLongitude = 0.0
    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            
            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUIEnable()
        actIndicator.stopAnimating()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        locationField.text = ""
        websiteField.text = ""
        dismiss(animated: true, completion: nil)
    }

    @IBAction func findLocationButtonPressed(_ sender: Any) {
        guard let location = locationField.text, location != "" else {
            createAlert(title: "Error", message: "Please enter location")
            return
        }
        
        guard let url = websiteField.text, url != "", url.hasPrefix("https://") else {
            createAlert(title: "Error", message: "Invalid URL. Please enter a URL that starts with 'https://'")
            return
        }
        
        setUIDisable()
        actIndicator.startAnimating()
        
        StudentInformation.NewUserLocation.mapString = location
        newLocation = location
        StudentInformation.NewUserLocation.mediaURL = url
        newURL = url
        
        getCoordinatesFromLocation(location: newLocation)
    }
    
    func getCoordinatesFromLocation(location: String) {
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {
            (placemarks, error) in
            // No internet connection
            guard (error == nil) else {
                print("Print Error: \(String(describing: error!.localizedDescription))")
                
                self.createAlert(title: "Error", message: "Could not calculate coordinates. Check your internet connection.")
                self.setUIEnable()
                
                return
            }
            let placemark = placemarks?.first
            
            guard let placemarkLatitude = placemark?.location?.coordinate.latitude else {

                self.createAlert(title: "Error", message: "Could not calculate latitude coordinate. Re-try location.")
                self.setUIEnable()
                return
            }
            
            StudentInformation.NewUserLocation.latitude = placemarkLatitude
            
            guard let placemarkLongitude = placemark?.location?.coordinate.longitude else {
                self.createAlert(title: "Error", message: "Could not calculate. Re-try location.")
                self.setUIEnable()
                return
            }
            
            StudentInformation.NewUserLocation.longitude = placemarkLongitude
            
            print("geCoordinatesOfLocation: Lat: \(StudentInformation.NewUserLocation.latitude), Lon: \(StudentInformation.NewUserLocation.longitude)")
            
            self.passDataToNextViewController()
        }
    }
    
    func passDataToNextViewController() {
        let addLocationMapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController
        self.navigationController?.pushViewController(addLocationMapVC, animated: true)
    }

}
