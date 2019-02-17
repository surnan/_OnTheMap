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
        //stack.alignment = .center  //Causes very bad things to happen
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo-u")
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var insertSpaceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var loginButton: UIButton = {  //Need the lazy to have height anchor in definition
        var button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("Log In", for: .normal)
        button.setTitle("Connecting ...", for: .selected)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLoginButton(_:)), for: .touchUpInside)
        return button
    }()
    
    var facebookLoginButton: LoginButton = {
        let button = LoginButton(readPermissions: [.publicProfile])
        return button
    }()

    
    var registrationTextLink: UITextView = {
       let textView = UITextView()
        let myAttributes: [NSAttributedString.Key: Any]? = [
            NSMutableAttributedString.Key.font : UIFont(name: "Georgia", size: 15) as Any
        ]
        let myMutableString = NSMutableAttributedString(string: "Don't have an account? Sign Up ", attributes: myAttributes)
        let _ = myMutableString.setAsLink(textToFind: "Sign Up", linkURL: "https://www.udacity.com")
        textView.attributedText = myMutableString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK:- UI Code
    func setupUI(){

        [logoImage, insertSpaceLabel, emailTextField, passwordTextField, loginButton, facebookLoginButton, registrationTextLink].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            loginStack.addArrangedSubview($0)
        }
        
        
        view.addSubview(loginStack)
        
        loginStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        loginStack.anchor(top: logoImage.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 25, left: 50, bottom: 0, right: 50), size: .zero)
        
        checkFacebook()
    }
    
    func preparingToLoadMainTabController() {
        showPassThroughNetworkActivityView()
        navigationController?.pushViewController(MainTabBarController(), animated: false)
    }
    

}
