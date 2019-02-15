//
//  LoginController+Facebook.swift
//  _OnTheMap
//
//  Created by admin on 2/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore


extension LoginController {
    //MARK:- Facebook protocol functions
    
    func checkFacebook(){
        if let _ = AccessToken.current  {          //True === Facebook logged in
            print("Facebook logged in.  Access Token Below:")
        } else {
            print("Facebook not logged in")
        }
    }
    
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let err):
            print(err)
        case .cancelled:
            print("cancelled")
        case .success(_,_,_):
            print("success")
            navigationController?.pushViewController(MainTabBarController() , animated: true)
//            present(MainTabBarController, animated: true)
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("logged out")
        UdacityClient.logout {}
        navigationController?.popToRootViewController(animated: true)
    }
}
