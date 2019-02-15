//
//  UdacityPublicUserData.swift
//  _OnTheMap
//
//  Created by admin on 2/15/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

struct emailType: Codable {
    var address: String
    var _verification_code_sent: String
    var _verified: Bool
}

struct bigAssDictionary: Codable {
    var firstName: String        ////////////////////////////////////////////////
    var email: emailType
    var badges: [String]
    var cohortKeys: [String]
    var memberships: [String]
    var affiliateProfiles: [String]
    var socialAccounts: [String]
    var imageUrl: String
    var lastName: String            ////////////////////////////////////////////////
    var nickname: String
    var registered: Bool
    var isGuard: [[String:String]]
    var key: String                 ////////////////////////////////////////////////
    var emailPreferences: [[String:String]]
    var tags: [String]
    var principals: [String]
    var employerSharing: Bool
    var hasPassword: Bool
    var enrollments: [String]

    enum CodingKeys: String, CodingKey {
            case firstName = "first_name"    ////////////////////////////////////////////////
            case email
            case badges
            case cohortKeys = "cohort_keys"
            case memberships = "_memberships"
            case affiliateProfiles = "_affiliate_profiles"
            case socialAccounts = "social_accounts"
            case imageUrl = "image_url"
            case lastName = "lastname"             ////////////////////////////////////////////////
            case nickname
            case registered = "_registered"
            case isGuard = "guard"
            case key                 ////////////////////////////////////////////////
            case emailPreferences = "email_preferences"
            case tags
            case principals = "_principals"
            case employerSharing = "employer_sharing"
            case hasPassword = "_has_password"
            case enrollments = "_enrollments"
    }
}


struct UdacityPublicUserData: Codable {
    var user: String
    var bigAssDictionary: String
}
