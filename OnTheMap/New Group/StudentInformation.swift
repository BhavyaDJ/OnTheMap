//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation


struct StudentInformation {
    
    let objectId : String?
    let firstName: String?
    let lastName : String?
    let latitude : Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL : String?
    let uniqueKey: String?
    let updatedAt: String?
    let createdAt: String?
    
    init?(dictionary: [String: AnyObject]) {
        
        self.objectId = dictionary[ParseConstants.JSONResponseKeys.ObjectId] as? String
        self.uniqueKey = dictionary[ParseConstants.JSONResponseKeys.UniqueKey] as? String
        self.firstName = dictionary[ParseConstants.JSONResponseKeys.FirstName] as? String
        self.lastName = dictionary[ParseConstants.JSONResponseKeys.LastName] as? String
        self.latitude = dictionary[ParseConstants.JSONResponseKeys.Latitude] as? Double
        self.longitude = dictionary[ParseConstants.JSONResponseKeys.Longitude] as? Double
        self.mapString = dictionary[ParseConstants.JSONResponseKeys.MapString] as? String
        self.mediaURL = dictionary[ParseConstants.JSONResponseKeys.MediaURL] as? String
        self.createdAt = dictionary[ParseConstants.JSONResponseKeys.CreatedAt] as? String
        self.updatedAt = dictionary[ParseConstants.JSONResponseKeys.UpdatedAt] as? String
        
    }
    
    static func studentInformationFromResults(_ results: [[String: AnyObject]]) -> [StudentInformation] {
        
        var studentLocations = [StudentInformation]()
        
        for result in results {
            studentLocations.append(StudentInformation(dictionary: result)!)
        }
        
        return studentLocations
    }
    
    
    // Stores current user's data on most recent post
    struct UserData {
        static var uniqueKey = ParseConstants.StudentLocationItem.uniqueKey
        static var firstName = ParseConstants.StudentLocationItem.firstName
        static var lastName = ParseConstants.StudentLocationItem.lastName
        static var objectId = ""
        static var latitude = 0.0
        static var longitude = 0.0
        static var mapString = ""
        static var mediaURL = ""
    }
    
    // Location dictionary
    static var userLocationDictionary : [String: AnyObject] = [
        "objectIdd" : UserData.objectId as AnyObject,
        "uniqueKey" : UserData.uniqueKey as AnyObject,
        "firstName" : UserData.firstName as AnyObject,
        "lastName" : UserData.lastName as AnyObject,
        "latitude" : UserData.latitude as AnyObject,
        "longitude" : UserData.longitude as AnyObject,
        "mapString" : UserData.mapString as AnyObject,
        "mediaURL" : UserData.mediaURL as AnyObject
    ]
    
    // Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func userLocationFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        var userLocations = [StudentInformation]()
        
        // iterate through array
        for result in results {
            userLocations.append(StudentInformation(dictionary: result)!)
        }
        
        return userLocations
    }
    
    // New User Location (User adds new location)
    struct NewUserLocation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
    
}
