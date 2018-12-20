//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 15/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityClient.sharedInstance().taskForDELETELogoutMethod()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        reloadData()
    }
    
    func reloadData() {
        
        //Create constants to prepare for refreshing the two view controllers
        let mapViewController = self.viewControllers?[0] as! MapViewController
        let tableViewController = self.viewControllers![1] as! TableViewController
        
        //Get 100 student locations from Parse
        ParseClient.sharedInstance().getLocationsRequest() { (success, errorString) in
            
            guard success == true else {
            
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: "Failed to download student location data.")
                }
                
                return
            }
            
            performUIUpdatesOnMain {
                //Update UI in both MapVC and TableVC
                mapViewController.displayUpdatedAnnotations()
                tableViewController.refreshTableView()
            }
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
}
