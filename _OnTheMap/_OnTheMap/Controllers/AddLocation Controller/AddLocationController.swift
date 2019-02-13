//
//  AddLocationController.swift
//  _OnTheMap
//
//  Created by admin on 2/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


protocol AddLocationControllerDelegate{
    func getMapString()-> String
    func getURLString()-> String
    func getLoction()-> CLLocation
}

class AddLocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, AddLocationControllerDelegate {
    //MARK:- Protocol Functions
    func getURLString() -> String {return urlTextField.text ?? ""}
    func getLoction() -> CLLocation {return globalLocation}
    func getMapString()-> String{return locationTextField.text ?? ""}
    
    //MARK:- Local Variables

    var mapString = ""
    var mediaURL = ""
    var globalLocation = CLLocation()
    
    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.clearsOnBeginEditing = true
        textField.clearButtonMode = .whileEditing
        textField.defaultTextAttributes = black25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
    lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
//        textField.clearsOnBeginEditing = true
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.defaultTextAttributes = black25textAttributes
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a Website", attributes: grey25textAttributes)
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
    lazy var findLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleFindLocation), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_world"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    func setupNavigationPane(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Add Location"
    }
    
    @objc func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        urlTextField.delegate = self
        locationTextField.delegate = self
        
        setupNavigationPane()
        
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 15
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [locationTextField, urlTextField, findLocationButton].forEach{stackView.addArrangedSubview($0)}
        [stackView, locationImageView].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 50),
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            urlTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            ])
    }
}
