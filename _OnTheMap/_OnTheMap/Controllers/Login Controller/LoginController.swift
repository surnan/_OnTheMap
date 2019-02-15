//
//  ViewController.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginController: UIViewController, UITextFieldDelegate, LoginButtonDelegate {

    var task: URLSessionTask?
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: grey25textAttributes)
        //textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) //prevents entered text from starting at left border.
        //But doesn't work with borderStyle = .roundedRect.  Rectangle Border shifts with text
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clipsToBounds = true
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: grey25textAttributes)
        textField.isSecureTextEntry = true
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clipsToBounds = true
        return textField
    }()
    
    private var loginStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo-u")
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Login To Udacity"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private var loginButton: UIButton = {  //Need the lazy to have height anchor in definition
        var button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var facebookLoginButton: LoginButton = {
        let button = LoginButton(readPermissions: [.publicProfile])
        return button
    }()
    
    
    //MARK:- UI Code
    private func setupUI(){
        [logoImage, loginLabel, emailTextField, passwordTextField, loginButton, facebookLoginButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            loginStack.addArrangedSubview($0)
        }
        view.addSubview(loginStack)
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        loginStack.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .zero)
        checkFacebook()
    }
    
    func preparingToLoadMainTabController() {
        showPassThroughNetworkActivityView()
        navigationController?.pushViewController(MainTabBarController(), animated: false)
    }
    
    
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
