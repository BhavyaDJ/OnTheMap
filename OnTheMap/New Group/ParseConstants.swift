//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation

class ParseConstants {
    
    struct URL {
        static let ApiScheme: String = "https"
        static let ApiHost: String = "parse.udacity.com"
        static let ApiPath: String = "/parse/classes"
        static let BaseURL: String = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    struct Methods {
        static let Session = "/session"
        static let User = "/users"
        static let studentLocation = "/StudentLocation"
    }
    
    
    struct APIHeaderKeys {
        static let ID = "X-Parse-Application-Id"
        static let Key = "X-Parse-REST-API-Key"
        static let xsrfToken = "X-XSRF-TOKEN"
        
    }
    
    struct APIHeaderValues {
        static let AppID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
    }
    
    struct URLRequest {
        static let getMethod = "GET"
        static let postMethod = "POST"
        static let putMethod = "PUT"
        static let deleteMethod = "DELETE"
        
    }
    
    struct JSONResponseKeys {
        static let ObjectId: String = "objectId"
        static let UniqueKey: String = "uniqueKey"
        static let FirstName: String = "firstName"
        static let LastName: String = "lastName"
        
        static let MapString: String = "mapString"
        static let MediaURL: String = "mediaURL"
        static let Latitude: String = "latitude"
        static let Longitude: String = "longitude"
        static let CreatedAt: String = "createdAt"
        static let UpdatedAt: String = "-updatedAt"
        static let Error: String = "error"
        static let Results: String = "results"
        
    }
    
    struct StudentLocationItem {
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct QueryItemKeys {
        static let limit = "limit"
        static let skip = "skip"
        static let order = "order"
        static let Where = "where"
        static let contentType = "Content-Type"
        
        
    }
    
    struct QueryItemValues {
        static let limit = "100"
        static let order = "-updatedAt"
        static let contentTypeValue = "application/json"
        
    }
    
}
