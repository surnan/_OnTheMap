//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


struct MarkerInfo: Hashable {
    var firstName: String
    var lastName: String
    var latitude: Double
    var longitude: Double
    var mediaURL: String
}

class Students {
    static var all = [StudentInfo]()
    static var pinArray = [StudentInfo]()
    
    class func loadPins(){
        var mySet = Set<MarkerInfo>()
        let myShortArray = self.all.filter{
            return mySet.insert(MarkerInfo(firstName: $0.firstName ?? "",
                                           lastName: $0.lastName ?? "",
                                           latitude: $0.latitude ?? 0,
                                           longitude: $0.longitude ?? 0,
                                           mediaURL: $0.mediaURL ?? "")).inserted
        }
        pinArray = myShortArray
//        print("myShortArray.count --> \(myShortArray.count)")
//        print("mySet.count --> \(mySet.count)")
    }
}

public func orderedSet<T: Hashable>(array: Array<T>) -> Array<T> {
    var unique = Set<T>()
    return array.filter { return unique.insert($0).inserted}
}


extension Array where Element:Hashable {
    var orderedSet: Array {
        var unique = Set<Element>()
        return filter { element in
            return unique.insert(element).inserted
        }
    }
}
