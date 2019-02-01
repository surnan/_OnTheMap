//
//  LoginController+Actions.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension LoginController{
    
    //MARK:- Actions
    @objc func handleLoginButton(_ sender: UIButton){
        if passwordTextField.text == "" || emailTextField.text == "" {
            let alertController = UIAlertController(title: "Login Error", message: "Both fields are mandatory", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
            return
        }
        
        UdacityClient.authenticateSession(name: emailTextField.text!, password: passwordTextField.text!) { (err) in
            if err == nil {
                self.navigationController?.pushViewController(MainTabBarController(), animated: false)
            } else {
                let alertController = UIAlertController(title: "Login Error", message: "Invalid combination for name and password", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true)
            }
        }
    }
    
    
    @objc func handleFacebookButton(_ sender: UIButton){
        
    }
}
