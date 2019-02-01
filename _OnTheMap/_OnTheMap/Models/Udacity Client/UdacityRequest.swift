//
//  AuthenticationRequest.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct Credentials: Codable {
    var username: String
    var password: String
}

struct UdacityRequest: Codable {
    var udacity: Credentials
}




