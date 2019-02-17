//
//  TextField+Extensions.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension UITextField {
    var isEmpty: Bool {
        guard let text = self.text, text.isEmpty else { return false}
        return true
    }
}
