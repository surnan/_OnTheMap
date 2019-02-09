//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Students {
    static var all = [PostedStudentInfoResponse]()
    static var uniques = [PostedStudentInfoResponse]()
    
    private struct MarkerInfo: Hashable {
        var firstName: String
        var lastName: String
        var latitude: Double
        var longitude: Double
        var mediaURL: String
    }
    
    enum Index {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }
    
    class func loadPins(){
        var mySet = Set<MarkerInfo>()
        let myShortArray = self.all.filter{
            
//            print("objectID = \($0.objectId ?? "No ID listed") ")
            
//            guard let mediaURL = $0.mediaURL, let _ = URL(string: mediaURL), $0.firstName != nil, $0.lastName != nil else {return false}
            guard $0.firstName != nil, $0.lastName != nil else {return false}
            return mySet.insert(MarkerInfo(firstName: $0.firstName ?? "",
                                           lastName: $0.lastName ?? "",
                                           latitude: $0.latitude ?? 0,
                                           longitude: $0.longitude ?? 0,
                                           mediaURL: $0.mediaURL ?? "")).inserted
        }
        uniques = myShortArray
    }
}

public func orderedSet<T: Hashable>(array: Array<T>) -> Array<T> {
    var uniqueElement = Set<T>()
    return array.filter { return uniqueElement.insert($0).inserted}
}


extension Array where Element:Hashable {
    var orderedSet: Array {
        var unique = Set<Element>()
        return filter { element in
            return unique.insert(element).inserted
        }
    }
}
