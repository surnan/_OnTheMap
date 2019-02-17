//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}

struct PutPostRequest: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}
