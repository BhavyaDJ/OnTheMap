//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import Foundation

class ParseClient {
    
    static let shared = ParseClient()
    //MARK: Properties
    var session = URLSession.shared
    
    
    //MARK: GET single student location request.
    func taskForGetALocation(completionHandlerForGETALocation: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        var components = URLComponents()
        
        components.scheme = ParseConstants.URL.ApiScheme
        components.host = ParseConstants.URL.ApiHost
        components.path = ParseConstants.URL.ApiPath
        components.queryItems = [URLQueryItem]()
        
        var request = URLRequest(url: components.url!)
        
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.Key)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETALocation(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            completionHandlerForGETALocation(data, nil)
            
        }
        
        task.resume()
    }
    
    
    //MARK: GET Multiple student locations requests.
    func taskForGETLocationsRequest(completionHandlerForGETLocationsRequest : @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.Key)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETLocationsRequest(nil, NSError(domain: "taskForParseRequest", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            completionHandlerForGETLocationsRequest(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
    }
    //MARK: POST
    func taskForPOSTAStudentLocation(jsonBody: String, completionHandlerForPOST: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        var request = URLRequest(url: URL(string: ParseConstants.URL.BaseURL)!)
        request.httpMethod = "POST"
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.Key)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            completionHandlerForPOST(data, nil)
        }
        task.resume()
        return task
    }
    
    //MARK: PUT
    func updateStudentLocation(jsonBody: String, completionHandlerForPUT: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        let urlString = ParseConstants.URL.BaseURL
        
        print("urlString for PUT: \(urlString)")
        print("User Object ID for PUT: \(StudentInformation.UserData.objectId)")
        
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue(ParseConstants.APIHeaderValues.AppID, forHTTPHeaderField: ParseConstants.APIHeaderKeys.ID)
        request.addValue(ParseConstants.APIHeaderValues.ApiKey, forHTTPHeaderField: ParseConstants.APIHeaderKeys.Key)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            //
            completionHandlerForPUT(data, nil)
        }
        task.resume()
        return task
    }
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: ":\"\(key)}") != nil {
            return method.replacingOccurrences(of: ":\"\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // Parse data: Convert Data into JSON
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    
    
    //Create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], method: String? = nil, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseConstants.URL.ApiScheme
        components.host = ParseConstants.URL.ApiHost
        components.path = ParseConstants.URL.ApiPath + (method ?? "") + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
    
}
