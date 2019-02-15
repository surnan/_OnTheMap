//
//  LoginController+Actions.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

extension LoginController{
    
    //MARK:- Actions
    @objc func handleLoginButton(_ sender: UIButton){
        if task != nil {
            print("task call cancelled")
            return
        }
        
        if passwordTextField.text == "" || emailTextField.text == "" {
            showOKAlert(title: "Missing Entry", message: "Both fields are needed for succesful login")
            showFinishNetworkRequest()
            return
        }
        
        showNONPassThroughNetworkActivityView()
        task = UdacityClient.authenticateSession(name: emailTextField.text ?? "", password: passwordTextField.text ?? "") {[weak self] (udacityErrString, err) in
            if let udacityErrString = udacityErrString {
                self?.showOKAlert(title: "Login Error", message: udacityErrString)
            } else if let err = err{
                self?.showOKAlert(title: "Network Timed Out", message: "Unable to connect")
                self?.showFinishNetworkRequest()
                print("\n\n\nUNKNOWN ERROR \n\n\n\n \(String(describing: err))")
            } else {
                self?.preparingToLoadMainTabController()
                self?.navigationController?.pushViewController(MainTabBarController() , animated: true)
            }
            self?.task = nil
            self?.showFinishNetworkRequest()
        }
    }
}

