//
//  StudentData.swift
//  OnTheMap
//
//  Created by Bhavya D J on 14/11/18.
//  Copyright © 2018 Bhavya D J. All rights reserved.
//

import UIKit

class StudentData: NSObject {
    
    static let sharedInstance = StudentData()
    
    var arrayOfStudentLocations = [StudentInformation]()
    
}
