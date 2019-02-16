//
//  GetStudentLocationResponse.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct GetStudentLocationResponse: Codable {
    var createdAt: String?
    var firstName: String?
    var lastName:  String?
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt
        case firstName
        case lastName
        case latitude
        case longitude
        case mapString
        case mediaURL
        case objectId
        case uniqueKey
        case updatedAt
    }
}


struct GetStudentLocationResponse2: Codable {
    var results: [GetStudentLocationResponse]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
