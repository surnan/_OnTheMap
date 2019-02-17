//
//  AddAnnotation+UITextField.swift
//  _OnTheMap
//
//  Created by admin on 2/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension AddLocationController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isFirstResponder == true {
            textField.placeholder = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if locationTextField.isEmpty {
            locationTextField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        }
        
        if urlTextField.isEmpty {
            urlTextField.attributedPlaceholder = NSAttributedString(string: "Enter a Website", attributes: grey25textAttributes)
        } else {
            urlTextField.text =  urlTextField.text?._prependHTTPifNeeded()
        }
    }
}
