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
//    func getMapString()-> String
//    func getURLString()-> String
//    func getLoction()-> CLLocation
    func getPutPostInfo() -> (
        object: String?,
        firstName: String,
        lastName: String,
        key: String,
        urlString: String,
        location: CLLocation,
        mapString: String)?
}

class AddLocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, AddLocationControllerDelegate {
    
    var delegate: MaintTabBarControllerDelegate?
    
    //MARK:- Protocol Functions
    
    
    func getPutPostInfo() -> (object: String?, firstName: String, lastName: String, key: String, urlString: String,location: CLLocation,mapString: String)? {
        if let myDelegate = delegate {
            return (object: myDelegate.getPutPostInfo().object,
                    firstName: myDelegate.getPutPostInfo().firstName,
                    lastName: myDelegate.getPutPostInfo().lastName,
                    key: myDelegate.getPutPostInfo().key,
                    urlString: urlTextField.text ?? "",
                    location: globalLocation,
                    mapString: locationTextField.text ?? "")
        } else {
            return nil
        }
    }
    
    
    func getURLString() -> String {return urlTextField.text ?? ""}
    func getLoction() -> CLLocation {return globalLocation}
    func getMapString()-> String{return locationTextField.text ?? ""}
    
    //MARK:- Local Variables
    var mapString = ""
    var mediaURL = ""
    var globalLocation = CLLocation()
    
    let geoCoder = CLGeocoder()
    
    
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.defaultTextAttributes = black25textAttributes
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        return textField
    }()
    
    var urlTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.defaultTextAttributes = black25textAttributes
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a Website", attributes: grey25textAttributes)
        return textField
    }()
    
    private var findLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitle("Searching...", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleFindLocation), for: .touchUpInside)
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    private let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_world"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func setupNavigationPane(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Add Location"
    }
    
    @objc private func handleCancel(){
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
        
        [locationTextField, urlTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }
        
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
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showFinishNetworkRequest()
        findLocationButton.isSelected = false
    }
}
