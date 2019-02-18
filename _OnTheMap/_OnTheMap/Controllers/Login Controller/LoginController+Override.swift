//
//  LoginController+Overload.swift
//  _OnTheMap
//
//  Created by admin on 2/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension LoginController{
    
    //MARK:- Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //line below prevents us from showing unnecessary bar button item until Tab Controller fully loads
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        facebookLoginButton.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showFinishNetworkRequest()
        navigationController?.navigationBar.isHidden = false
    }
}
