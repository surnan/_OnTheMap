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
        [greyShadeSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyShadeSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
        navigationController?.pushViewController(MainTabBarController(), animated: false)
    }
    
    @objc func handleLoginButton(_ sender: UIButton){
        if passwordTextField.text == "" || emailTextField.text == "" {
            let alertController = UIAlertController(title: "Missing Entry", message: "Both fields are needed for succesful login", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true)
            return
        }
        
        UdacityClient.authenticateSession(name: emailTextField.text!, password: passwordTextField.text!) {[weak self] (udacityErrString, err) in
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
            }
        }
        
        
        
        
        
        
    }
    
    
    //MARK:- Facebook protocol functions
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        preparingToLoadMainTabController()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        UdacityClient.logout {}
        navigationController?.popToRootViewController(animated: true)
    }
}

let standardButtonHeight: CGFloat = customUIHeightSize
class FacebookButton: FBSDKLoginButton {
    override func updateConstraints() {
        // deactivate height constraints added by the facebook sdk (we'll force our own instrinsic height)
        for contraint in constraints {
            if contraint.firstAttribute == .height, contraint.constant < standardButtonHeight {
                // deactivate this constraint
                contraint.isActive = false
            }
        }
        super.updateConstraints()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: standardButtonHeight)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let logoSize: CGFloat = 24.0
        let centerY = contentRect.midY
        let y: CGFloat = centerY - (logoSize / 2.0)
        return CGRect(x: y, y: y, width: logoSize, height: logoSize)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if isHidden || bounds.isEmpty {
            return .zero
        }
        let imageRect = self.imageRect(forContentRect: contentRect)
        let titleX = imageRect.maxX
        let titleRect = CGRect(x: titleX, y: 0, width: contentRect.width - titleX - titleX, height: contentRect.height)
        return titleRect
    }
}



/*
 UdacityClient.authenticateSession(name: emailTextField.text!, password: passwordTextField.text!) { [weak self](err) in
 if err != nil {
 print("\n\n")
 print(err)
 print("\n\n\n\n\n\n\n")
 print(err?.localizedDescription)
 print("\n\n")
 } else {
 self?.preparingToLoadMainTabController()
 }
 }

 */
