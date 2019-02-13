//
//  ViewController.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
import FBSDKLoginKit
import FacebookLogin

class LoginController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate, LoginButtonDelegate {

    
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Email", attributes: grey25textAttributes)
        //textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) //prevents entered text from starting at left border.
        //But doesn't work with borderStyle = .roundedRect.  Rectangle Border shifts with text
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Password", attributes: grey25textAttributes)
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clearButtonMode = .whileEditing
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let greyShadeSuperView: UIView = {
        let _view = UIView()
        _view.backgroundColor = UIColor.grey196Half
        _view.translatesAutoresizingMaskIntoConstraints = false
        return _view
    }()
    
    var myActivityMonitor: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .whiteLarge
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    
    private lazy var loginButton: UIButton = {  //Need the lazy to have height anchor in definition
        var button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("Log In", for: .normal)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return button
    }()
    
    var myFacebookButton: FacebookButton = {
       let button = FacebookButton()
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    lazy var anotherFacebookButton: LoginButton = {
        let button = LoginButton(readPermissions: [.publicProfile])
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return button
    }()
        
    
    
    //MARK:- CODE STARTS HERE
    private func setupUI(){
//        [logoImage, loginLabel, emailTextField, passwordTextField, loginButton, myFacebookButton].forEach{loginStack.addArrangedSubview($0)}
        [logoImage, loginLabel, emailTextField, passwordTextField, loginButton, anotherFacebookButton].forEach{loginStack.addArrangedSubview($0)}
        view.addSubview(loginStack)
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        loginStack.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .zero)
        checkFacebook()
    }
    
    func checkFacebook(){
        if let _ = AccessToken.current  {          //True === Facebook logged in
            print("Facebook logged in.  Access Token Below:")
        } else {
            print("Facebook not logged in")
        }
    }
    
    
    
    //MARK:- Swift Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        //line below prevents us from showing unnecessary bar button item until Tab Controller fully loads
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
        myFacebookButton.delegate = self
        anotherFacebookButton.delegate = self
        setupUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        greyShadeSuperView.removeFromSuperview()
        myActivityMonitor.stopAnimating()
        navigationController?.navigationBar.isHidden = false
    }
    

}
