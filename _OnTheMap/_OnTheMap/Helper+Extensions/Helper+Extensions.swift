//
//  Helpers.swift
//  _OnTheMap
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//extension String {
//    var isValidURL: Bool {
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.endIndex.encodedOffset)) {
//            // it is a link, if the match covers the whole string
//            return match.range.length == self.endIndex.encodedOffset
//        } else {
//            return false
//        }
//    }
//    
//    func prependHTTPifNeeded()-> String{
//        let first4 = self.prefix(4)
//        if first4 != "http" {
//            return "http://" + self
//        } else {
//            return self
//        }
//    }
//}

extension String {
    var _isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(startIndex..., in: self)    //startIndex = position of first character in non-empty String
        return detector.firstMatch(in: self, range: range)?.range == range
    }
    
    func _prependHTTPifNeeded() -> String{
        if prefix(4) != "http" {
            return "http://" + self
        } else {
            return self
        }
    }
}
