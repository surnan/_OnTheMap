//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct PutRequest: Codable {
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
}


