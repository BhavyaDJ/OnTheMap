//
//  LoginVCExtensions.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {
    
    // MARK: Alerts
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: URL open
    func verifyUrl (urlString: String?) -> Bool {
        
        let app = UIApplication.shared
        
        if let urlString = urlString {
            if let url  = NSURL(string: urlString) {
                return app.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    // MARK: Keyboard Methods
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        
        
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        
    }
    
    // move the view back down when the keyboard is dismissed
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
}

extension LoginViewController {
    
    func setUIDisable() {
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
        signupButton.isEnabled = false
    }
    
    func setUIEnable() {
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        emailTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = true
        signupButton.isEnabled = true
    }
    
    
    // removes the text keyboard after touching anywhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
extension AddLocationViewController {
        
        func setUIDisable() {
            locationField.isEnabled = false
            websiteField.isEnabled = false
            findButton.isEnabled = false
        }
        
        func setUIEnable() {
            locationField.isEnabled = true
            websiteField.isEnabled = true
            findButton.isEnabled = true
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            locationField.resignFirstResponder()
            websiteField.resignFirstResponder()
        }
}
