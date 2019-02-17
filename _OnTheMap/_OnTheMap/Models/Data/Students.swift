//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Students {
    static var allStudentLocations = [StudentLocation]()
    static var validLocations = [VerifiedStudentLocation]()
    
//    static var allStudentLocations = [StudentLocation]()
//    static var validLocations = [VerifiedStudentLocation]()
    
    
    private class func loadValidLocations(){
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
           VerifiedStudentLocation(createdAt: $0.createdAt!,
                                             firstName: $0.firstName!,
                                             lastName: $0.lastName!,
                                             latitude: $0.latitude!,
                                             longitude: $0.longitude!,
                                             mapString: $0.mapString!,
                                             mediaURL: $0.mediaURL!,
                                             objectId: $0.objectId!,
                                             uniqueKey: $0.uniqueKey!,
                                             updatedAt: $0.updatedAt!)
        }
    }
    
    class func loadStudentLocationArrays(studentLocations: [StudentLocation]){
        Students.allStudentLocations = studentLocations
        Students.loadValidLocations()
    }
}
