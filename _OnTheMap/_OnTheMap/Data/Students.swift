//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

/*
 struct StudentInfo: Codable, Hashable {
 var objectId: String
 var uniqueKey: String?
 var firstName: String?
 var lastName: String?
 var mapString: String?
 var mediaURL: String?
 var latitude: Double?
 var longitude: Double?
 var createdAt: String?
 var updatedAt: String?
 }
 */

import Foundation


struct MarkerInfo: Hashable {
    var firstName: String
    var lastName: String
    
}


class Students {
    static var all = [StudentInfo]()
    static var pins = [MarkerInfo]()
    
    
    class func loadPins(){
        
        var mySet = Set<MarkerInfo>()
        
        let myShortArray = self.all.filter{
            return mySet.insert(MarkerInfo(firstName: $0.firstName ?? "", lastName: $0.lastName ?? "")).inserted
        }
        
        print("myShortArray.count --> \(myShortArray.count)")
        print("mySet.count --> \(mySet.count)")
    }
    
    
}

public func orderedSet<T: Hashable>(array: Array<T>) -> Array<T> {
    var unique = Set<T>()
    //    return array.filter { element in
    //        return unique.insert(element).inserted
    //    }
    //    return array.filter { return unique.insert($0).inserted}
    let temp = array.filter { return unique.insert($0).inserted}
    print(unique)
    
    return temp
}

//orderedSet(array: numberArray)  // [10, 1, 2, 3, 15, 4, 5, 6, 7, 12, 8, 45]


extension Array where Element:Hashable {
    var orderedSet: Array {
        var unique = Set<Element>()
        return filter { element in
            return unique.insert(element).inserted
        }
    }
}
