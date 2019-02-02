//
//  Students.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Students {
    static var all = [StudentInfo]()
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
