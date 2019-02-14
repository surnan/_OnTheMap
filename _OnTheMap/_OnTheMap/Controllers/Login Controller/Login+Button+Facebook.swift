//
//  LoginController+Actions.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

extension LoginController{
    
    //MARK:- Actions
    private func preparingToLoadMainTabController() {
        showUserNetworkRequestInAction()
        navigationController?.pushViewController(MainTabBarController(), animated: false)
    }
    
    
    func showUserNetworkRequestInAction(){
        [greyShadeSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyShadeSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
    }
    
    
    @objc func handleLoginButton(_ sender: UIButton){
        if task != nil {
            print("task call cancelled")
            return
        }
        
        if passwordTextField.text == "" || emailTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Entry", message: "Both fields are needed for succesful login", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
            return
        }
        
        showUserNetworkRequestInAction()
        print("BEFORE UDACITYCLIENT.AUTHENTICATESESSION")
        task = UdacityClient.authenticateSession(name: emailTextField.text!, password: passwordTextField.text!) {[weak self] (udacityErrString, err) in
            print("calling UDACITYCLIENT.AUTHENTICATESESSION")
            if let udacityErrString = udacityErrString {
                let myAlertController = UIAlertController(title: "Login Error", message: udacityErrString, preferredStyle: .alert)
                myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(myAlertController, animated: true)
            } else if let err = err{
                let myAlertController = UIAlertController(title: "Network Timed Out", message: "Unable to connect", preferredStyle: .alert)
                myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(myAlertController, animated: true)
                print("\n\n\nUNKNOWN ERROR \n\n\n\n \(String(describing: err))")
            } else {
                self?.preparingToLoadMainTabController()
                self?.navigationController?.pushViewController(MainTabBarController() , animated: true)
            }
            self?.task = nil
            self?.deleteVisualNetworkActivityChanges()
        }
    }
    
    
    //MARK:- Facebook protocol functions
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let err):
            print(err)
        case .cancelled:
            print("cancelled")
        case .success(_,_,_):
            print("success")
            preparingToLoadMainTabController()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
        UdacityClient.logout {}
        navigationController?.popToRootViewController(animated: true)
    }
}

