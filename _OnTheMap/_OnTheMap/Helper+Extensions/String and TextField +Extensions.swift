//
//  Helpers.swift
//  _OnTheMap
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

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

extension UITextField {
    var isEmpty: Bool {
        guard let text = self.text, text.isEmpty else { return false}        
        return true
    }
}



