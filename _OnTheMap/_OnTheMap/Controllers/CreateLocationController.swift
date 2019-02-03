//
//  CreateLocationController.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CreateLocationController: UIViewController, UITextFieldDelegate{
    
    var fullScreenStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var topView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey196
        label.numberOfLines = -1
        label.textAlignment = .center
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 30) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.skyBlue4
        ]
        let attributes2: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font :  UIFont(name: "Arial-BoldMT", size: 30) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.steelBlue4
        ]
        var totalAttributes = NSMutableAttributedString(string:"Where are you", attributes:attributes1)
        totalAttributes.append(NSMutableAttributedString(string:"\nstudying", attributes:attributes2))
        totalAttributes.append(NSMutableAttributedString(string:"\ntoday?", attributes:attributes1))
        label.attributedText = totalAttributes
        return label
    }()
    
    
    var midView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.dodgerBlue4
        return view
    }()
    
    let locationTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.grey196
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Enter Your Location Here", attributes: attributes1)
        textField.textAlignment = .center
        textField.clearsOnInsertion = true
        textField.clearsOnBeginEditing = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var btmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grey196
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightGray
        loadFullScreenStackView()
        locationTextField.delegate = self
        
        view.addSubview(fullScreenStackView)
        NSLayoutConstraint.activate([
            fullScreenStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fullScreenStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fullScreenStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        setupMidView()
        
    }
    
    
    func loadFullScreenStackView(){
        [topView, midView, btmView].forEach{fullScreenStackView.addArrangedSubview($0)}
    }
    
    
    func setupMidView(){
        midView.insertSubview(locationTextField, at: 0)
        NSLayoutConstraint.activate([
            locationTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -15),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ])
    }
    
    func setupBtmView(){
        
    }
 
    
    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    
    
    
}
