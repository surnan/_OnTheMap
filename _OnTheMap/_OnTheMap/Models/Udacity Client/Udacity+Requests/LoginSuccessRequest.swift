//
//  LoginRequestResponses.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct Account: Codable {
    var registered: Bool
    var key: String
    
}

struct Session: Codable {
    var expiration: String
    var id: String
}


struct LoginSuccessRequest: Codable {
    var account: Account
    var session: Session
}
