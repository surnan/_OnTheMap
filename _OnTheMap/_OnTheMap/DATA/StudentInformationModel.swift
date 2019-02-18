//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class StudentInformationModel {
    private static var allStudentLocations = [StudentLocation]()
    private static var validStudentLocations = [VerifiedStudentLocation]()
    
    static var getAllStudentLocations:[StudentLocation] {
        return allStudentLocations
    }
    
    static var getVerifiedStudentLocations:[VerifiedStudentLocation] {
        return validStudentLocations
    }
    
    
    private class func loadValidLocations(){
        let nonNilArray = self.getAllStudentLocations.filter{
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
        
        validStudentLocations = nonNilArray.map{
            VerifiedStudentLocation(createdAt: $0.createdAt!,
                                    firstName: $0.firstName!,
                                    lastName: $0.lastName!,
                                    latitude: $0.latitude!,
                                    longitude: $0.longitude!,
                                    mapString: $0.mapString!,
                                    mediaURL: $0.mediaURL!,
                                    objectId: $0.objectId!,
                                    //                                    uniqueKey: $0.uniqueKey ?? " ",
                uniqueKey: $0.uniqueKey!,
                updatedAt: $0.updatedAt!)
        }
    }
    
    class func loadStudentLocationArrays(studentLocations: [StudentLocation]){
        StudentInformationModel.allStudentLocations = studentLocations
        StudentInformationModel.loadValidLocations()
    }
}
