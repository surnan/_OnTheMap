//
//  ViewController.swift
//  OnTheMap
//
//  Created by admin on 1/31/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    
    
    
    let customFontSize: CGFloat = 25
    let customUIHeightSize: CGFloat = 55
    let cornerRadiusSize: CGFloat = 5
    
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
    
    lazy var facebookButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.darkBlue
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("FACEBOOK", for: .normal)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return button
    }()
    
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
    
    
    //MARK:- CODE STARTS HERE
    private func setupUI(){
        emailTextField.text = "4suresh@gmail.com"
        passwordTextField.text = "atDZ8=Gm%=VU"
        [logoImage, loginLabel, emailTextField, passwordTextField, loginButton, facebookButton].forEach{loginStack.addArrangedSubview($0)}
        view.addSubview(loginStack)
        loginLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        loginStack.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: 0, left: 50, bottom: 0, right: 50), size: .zero)
    }

    

    //MARK:- Swift Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
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
