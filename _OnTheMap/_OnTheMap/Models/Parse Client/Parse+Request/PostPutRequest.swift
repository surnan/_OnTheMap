//
//  PutPostRequest.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct PostPutRequest: Codable {
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mapString: String
    var mediaURL: String
    var uniqueKey: String
}
