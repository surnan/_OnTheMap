//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Students {
    static var allStudentLocations = [PostedStudentInfoResponse]()
    static var validLocations = [VerifiedPostedStudentInfoResponse]()
    
    class func loadValidLocations(){
        let nonNilArray = self.allStudentLocations.filter{
            guard $0.firstName != nil,
                $0.lastName != nil,
                $0.objectId != nil,
                $0.uniqueKey != nil,
                $0.mapString != nil,
                $0.mediaURL != nil,
                $0.latitude != nil,
                $0.longitude != nil,
                $0.createdAt != nil,
                $0.updatedAt != nil      else {return false}
            return true
        }

        validLocations = nonNilArray.map{
           VerifiedPostedStudentInfoResponse(objectId: $0.objectId!,
                                             uniqueKey: $0.uniqueKey!,
                                             firstName: $0.firstName!,
                                             lastName: $0.lastName!,
                                             mapString: $0.mapString!,
                                             mediaURL: $0.mediaURL!,
                                             latitude: $0.latitude!,
                                             longitude: $0.longitude!,
                                             createdAt: $0.createdAt!,
                                             updatedAt: $0.updatedAt!)
        }
    }
}
