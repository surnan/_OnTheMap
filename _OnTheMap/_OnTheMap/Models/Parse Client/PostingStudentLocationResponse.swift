//
//  postStudentLocationResponse.swift
//  _OnTheMap
//
//  Created by admin on 2/8/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct ParseResponse: Codable {
    var createdAt: String
    var objectId: String
}

struct PostPushResponse: Codable {
    var createdAt: String
    var objectId: String
}
