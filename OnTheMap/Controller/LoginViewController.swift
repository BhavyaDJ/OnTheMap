//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Properties
    var keyboardVisible = false
    
    @IBOutlet weak var udacityImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        setUIEnable()
        actIndicator.stopAnimating()
        
    }
    
    // 1. Check for empty text fields.
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        guard let username = emailTextField.text, username != "" else {
            createAlert(title: "Error", message: "Please enter your email address")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            createAlert(title: "Error", message: "Please enter your password")
            return
        }
        
        setUIDisable()
        actIndicator.startAnimating()
        
        // 2. Call 'authenticateUser'
        UdacityClient.sharedInstance().authenticateUser(myUserName: username, myPassword: password) { (success, errorString) in
            
            guard (success == true) else {
                
                performUIUpdatesOnMain {
                    self.createAlert(title: "Error", message: errorString)
                    self.setUIEnable()
                }
                
                return
            }
            
            // 3. Call 'getPublicUserData
            UdacityClient.sharedInstance().getPublicUserData() { (data, errorString) in
                guard (success == true) else {
                    
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Error", message: "unable to get Public User Data")
                        self.setUIEnable()
                        
                    }
                    
                    return
                }
                
                // MARK: 4. Get the User Student location(s)
                ParseClient.sharedInstance().taskForGetALocation() { (data, errorString) in
                    guard data != nil else {
                        
                        performUIUpdatesOnMain {
                            self.createAlert(title: "Error", message: "Unable to obtain Student Location data.")
                            self.setUIEnable()
                        }
                        return
                    }
                
                // MARK: 5. Get 100 student locations from Parse
                ParseClient.sharedInstance().taskForGETLocationsRequest() { (data, errorString) in
                        
                        guard (success == true) else {
                            
                            performUIUpdatesOnMain {
                                self.createAlert(title: "Error", message: "Failure to download student locations data.")
                                self.setUIEnable()
                            }
                            return
                        }
                    
                        self.completeLogin()
                        
                    }
                }
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: AnyObject) {
        let app = UIApplication.shared
        app.open(URL(string: "https://www.udacity.com")!)
    }
    
    
    private func completeLogin() {
        
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "InitialNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
    }
}
