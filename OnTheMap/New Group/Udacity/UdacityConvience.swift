//
//  UdacityConvience.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    
    /// MARK: Convenience method for extracting account 'key' and session 'id'
    func authenticateUser(myUserName: String, myPassword: String, completionHandlerForAuthenticateUser: @escaping (_ success:Bool, _ error:String) -> Void) {
        
        // Call taskForPOSTSession (from UdacityClient) and parse the JSON data
        taskForPOSTLoginMethod(username: myUserName, password: myPassword) { (data, error) in
            
            // MARK: Extract account key and session id
            // (1) Parse data
            guard (error == nil) else {
               
                print("GUARD in ERROR: MESSAGE: \(error!.localizedDescription)")
               
                completionHandlerForAuthenticateUser(false, UdacityConstants.ErrorMessages.NetworkConnectionError)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("GUARD in DATA: MESSAGE (Username or Password is incorrect).")
                completionHandlerForAuthenticateUser(false, UdacityConstants.ErrorMessages.UsernamePasswordError)
                return
            }
            
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForPOSTLoginMethod: Failed to parse data.")
                completionHandlerForAuthenticateUser(false, "Failed to parse data.")
                return
            }
            
            // (2) extract 'account' dictionary
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid account dictionary in parsed JSON data")
                return
            }
            // (2a) extract account 'key' and save in accountKey
            guard let myAccountKey = account["key"] as? String else {
                completionHandlerForAuthenticateUser(false,"No valid key in account dictionary.")
                return
            }
            
            // IF correct login info, then these will display account key and session id.
            // store account 'key'
            print("account key: \(myAccountKey)")
            self.accountKey = myAccountKey
            
            // (3) extract 'session' dictionary
            guard let session = parsedResult["session"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid session dictionary in pasrsed JSON data.")
                return
            }
            // (3a) extract session 'id' and save in session ID
            guard let mySessionID = session["id"] as? String else {
                completionHandlerForAuthenticateUser(false, "No valid id in session dictinary.")
                return
            }
            // store session 'id'
            print("session id: \(mySessionID)")
            self.sessionId = mySessionID
            
            // call completion handler
            completionHandlerForAuthenticateUser(true, "")
        }
    }
    
    
    // MARK: Convenience method for extracting first name and last name from public user data
    func getPublicUserData(completionHandlerForGETPublicUserData: @escaping (_ success:Bool, _ error:String)->Void) {
        
        // Call taskForGETPublicUserData (from UdacityClient) and parse the JSON data
        taskForGETPublicUserData(userID: self.accountKey ) {  (data, error) in
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGETPublicUserData(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }
            
            print("print 'data' for getPublicUserData: \(data)")
            
            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETPublicUserData: Failed to parse data")
                completionHandlerForGETPublicUserData(false, "Failed to parse data.")
                return
            }
            
            // (2) extract 'user' dictionary
            guard let user = parsedResult["user"] as? [String:AnyObject] else {
                completionHandlerForGETPublicUserData(false, "No valid 'user' dictionary in parsed JSON data")
                return
            }
            // (2a) extract account 'last_name' and save in lastName
            guard let lastName = user["last_name"] as? String else {
                completionHandlerForGETPublicUserData(false,"No valid 'last_name' key in 'user' dictionary.")
                return
            }
            // store last_name' 'key'
            self.lastName = lastName
            
            // (3a) extract user 'first_name' and save in firstName
            guard let firstName = user["first_name"] as? String else {
                completionHandlerForGETPublicUserData(false, "No valid 'first_name' key in 'user' dictinary.")
                return
            }
            // store user 'firstName'
            self.firstName = firstName
            
            completionHandlerForGETPublicUserData(true, "")
        }
    }
    
}
