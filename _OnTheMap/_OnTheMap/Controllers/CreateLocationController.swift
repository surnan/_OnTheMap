//
//  CreateLocationController.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


protocol CreateLocationControllerDelegate {
    func getLocation()-> String
}


class CreateLocationController: UIViewController, UITextFieldDelegate, CreateLocationControllerDelegate{
    
    func getLocation()->String {
        return locationTextField.text ?? ""
    }
    
    
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
    
    let findOnMapButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.clipsToBounds = true
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.steelBlue4
        ]
        button.setAttributedTitle(NSAttributedString(string: "Find on the Map", attributes: attributes1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        return button
    }()
    
    
    func setupTopBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightGray
        loadFullScreenStackView()
        locationTextField.delegate = self
    
        setupTopBar()
        
        view.addSubview(fullScreenStackView)
        NSLayoutConstraint.activate([
            fullScreenStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fullScreenStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fullScreenStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        setupMidView()
        setupBtmView()
        
    }
    
    
    func loadFullScreenStackView(){
        [topView, midView, btmView].forEach{fullScreenStackView.addArrangedSubview($0)}
    }
    
    
    func setupMidView(){
        midView.insertSubview(locationTextField, at: 0)
        NSLayoutConstraint.activate([
            locationTextField.centerYAnchor.constraint(equalTo: midView.centerYAnchor, constant: -15),
            locationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            locationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            ])
    }
    
    func setupBtmView(){
        view.addSubview(findOnMapButton)
        NSLayoutConstraint.activate([
            findOnMapButton.centerYAnchor.constraint(equalTo: btmView.centerYAnchor),
            findOnMapButton.widthAnchor.constraint(equalToConstant: 240),
            findOnMapButton.heightAnchor.constraint(equalToConstant: 50),
            findOnMapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
        //   findOnMapButton.setNeedsLayout()
        findOnMapButton.layoutIfNeeded()
        findOnMapButton.layer.cornerRadius = 0.075 * findOnMapButton.bounds.size.width
    }
 
    
    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    @objc func handleButton(){
        let newCreateAnnotationController = CreateAnnotation()
        newCreateAnnotationController.delegate = self
        let newVC = UINavigationController(rootViewController: newCreateAnnotationController)
        present(newVC, animated: true)
    }
}
