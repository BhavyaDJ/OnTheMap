//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{
    
    
    var accountKey = ""
    var sessionId = ""
    var firstName = ""
    var lastName = ""
    
    
    //Mark Properties
    let session = URLSession.shared

    //MARK: POST
    func taskForPOSTLoginMethod(username: String, password: String, completionHandlerForPOSTLoginMethod: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        //Build URL, configure rquest
        var request = URLRequest(url: URL(string: UdacityConstants.UdacityURL.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        //Make request
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error Message: \(String(describing: error!.localizedDescription))")
                
                completionHandlerForPOSTLoginMethod(nil, error!)
                return
            }
            // If an error occurs, print and renable UI
            func displayError(_ error: String) {
                print(error)
            }
            
            guard (error == nil) else {
                displayError("There was an error with your request: \(String(describing: error))")
                completionHandlerForPOSTLoginMethod(nil, error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2XX.")
                completionHandlerForPOSTLoginMethod(nil, error)
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request")
                completionHandlerForPOSTLoginMethod(nil, error)
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            completionHandlerForPOSTLoginMethod(newData, nil)
        }
        
        task.resume()
    }
    
    // MARK: GET
    func taskForGETPublicUserData(userID: String, completionHandlerForGETPublicUserData: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        // Get method url (userID)
        let methodURL = "https://www.udacity.com/api/users/\(userID)"
        print("userID: \(userID)")
        print("GET URL: \(methodURL)")
        
        let request = URLRequest(url: URL(string: methodURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completionHandlerForGETPublicUserData(nil, error!)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data!.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            completionHandlerForGETPublicUserData(newData, nil)
        }
        
        task.resume()
    }
    
    func taskForDELETELogoutMethod() {
        
        //Build URL, Configure request
        let request = NSMutableURLRequest(url: URL(string: UdacityConstants.UdacityURL.BaseURL)!)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            
            if cookie.name == "XSRF-TOKEN" {  xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        //Make the request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2XX.")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request.")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
            print("User has successfully logged out")
            
        }
        
        task.resume()
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
