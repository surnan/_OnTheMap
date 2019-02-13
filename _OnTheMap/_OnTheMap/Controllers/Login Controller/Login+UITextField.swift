//
//  Login+UITextField.swift
//  _OnTheMap
//
//  Created by admin on 2/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension LoginController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isFirstResponder == true {
            textField.placeholder = ""
        }
        //Because of security setting, passwordTextField clears everytime it's tapped
        //// textField.isSecureTextEntry = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if emailTextField.isEmpty {
            emailTextField.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: grey25textAttributes)
        }
        
        if passwordTextField.isEmpty {
            passwordTextField.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: grey25textAttributes)
        }
    }
}
