//
//  NSMutable+Extension.swift
//  _OnTheMap
//
//  Created by admin on 2/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation


extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
