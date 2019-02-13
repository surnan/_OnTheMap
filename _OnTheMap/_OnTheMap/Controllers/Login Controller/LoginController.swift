//
//  ViewController.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
//import FacebookLogin
import FBSDKLoginKit

//class LoginController: UIViewController, LoginButtonDelegate, FBSDKLoginButtonDelegate {
    class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Test")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("test 2222")
    }
    
    
    
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedText = NSMutableAttributedString(string: "Email", attributes: grey25textAttributes)
        //textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0) //prevents entered text from starting at left border.
        //But doesn't work with borderStyle = .roundedRect.  Rectangle Border shifts with text
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
//    lazy var passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.clearsOnBeginEditing = true
//        textField.defaultTextAttributes = grey25textAttributes
//        textField.attributedText = NSMutableAttributedString(string: "Password", attributes: grey25textAttributes)
//        textField.isSecureTextEntry = true
//        textField.layer.cornerRadius = cornerRadiusSize
//        textField.clipsToBounds = true
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
//        return textField
//    }()
    
    

    
    var loginStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo-u")
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var loginLabel: UILabel = {
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
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.defaultTextAttributes = grey25textAttributes
        textField.attributedText = NSMutableAttributedString(string: "Password", attributes: grey25textAttributes)
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = cornerRadiusSize
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {  //Need the lazy to have height anchor in definition
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
    

//    let facebookLoginButton = LoginButton(readPermissions: [.publicProfile])
    
//    lazy var facebookLoginButton: LoginButton = {
//       let button = LoginButton(readPermissions: [.publicProfile])
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
//        return button
//    }()
    
    
    
    

    //    FBSDKLoginManager().logOut()
    
//    lazy var myFaceBookLoginButton: UIButton = {
//       let button = UIButton()
//        button.backgroundColor = UIColor.blue
//        button.setAttributedTitle(NSMutableAttributedString(string: "Facebook Login", attributes: white25textAttributes), for: .normal)
//        button.addTarget(self, action: #selector(handleFacebookLoginButton3), for: .touchUpInside)
//        return button
//    }()
    
    
    let facebookFinal = FacebookButton()
    
    
//    @objc func handleFacebookLoginButton3(_ sender: UIButton){
//
//        if sender.backgroundColor == UIColor.blue {
//                sender.setTitle("LOGOUT", for: .normal)
//
//        }
//
//
//
//
//        let loginManager = LoginManager()
//        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (loginResult) in
//            switch loginResult {
//            case .failed(let error):
//                print(error)
//            case .cancelled:
//                print("User cancelled login.")
//            case .success(_, _, _):
//                print("Logged in!")
//            }
//        }
//    }
    
    let temp = FacebookButton()
    
    
    //MARK:- CODE STARTS HERE
    private func setupUI(){
        emailTextField.text = shazam
        passwordTextField.text = openSesame
//        facebookLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        [logoImage, loginLabel, emailTextField, passwordTextField, loginButton, temp].forEach{loginStack.addArrangedSubview($0)}
        view.addSubview(loginStack)
        
        
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        loginStack.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .zero)
        
        
        //        facebookLoginButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
        
        checkFacebook()
        
        
        
    }
    
    func checkFacebook(){
        if let _ = AccessToken.current  {          //True === Facebook logged in
            print("Facebook logged in.  Access Token Below:")
//            print(accessToken)
        } else {
            print("Facebook not logged in")
        }
    }
    
//    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        switch result {
//        case .failed(let err):
//            print("Error after logging in: \n\(err)")
//        case .cancelled:
//            print("Login was cancelled")
//        case .success(_,_,_):
//            print("success")
//        }
//    }
//
//    func loginButtonDidLogOut(_ loginButton: LoginButton) {
//        print("User Logged Out")
//    }
    
    
    //MARK:- Swift Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        facebookLoginButton.delegate = self
        temp.delegate = self
        setupUI()
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
