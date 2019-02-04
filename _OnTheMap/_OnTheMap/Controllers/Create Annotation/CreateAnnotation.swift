//
//  CreateAnnotation.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class CreateAnnotation:UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    
    let temp: [String: Any] = [
        "objectId":"MtsUNmdxzk",
        "uniqueKey":"Zoe",
        "firstName":"Zoe",
        "lastName":"Zboncak",
        "mapString":"alqassim",
        "mediaURL":"https://www.google.com",
        "latitude":25.946163,
        "longitude":43.219329,
        "createdAt":"2019-01-31T08:11:27.635Z",
        "updatedAt":"2019-01-31T08:11:27.635Z"
    ]
    
    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var inputLinkTextField: UITextField = {
        var textfield = UITextField()
        textfield.backgroundColor = UIColor.dodgerBlue4
        textfield.textColor = UIColor.white
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.grey196
            ])
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    var submitButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.white
        button.setAttributedTitle(NSAttributedString(string: "    Submit    ", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 20) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.dodgerBlue4
            ]), for: .normal)
        button.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        inputLinkTextField.delegate = self
        [mapView, inputLinkTextField, submitButton].forEach{view.addSubview($0)}
        
        
        let totalHeightCGFloat = view.bounds.size.height
        //  let totalWidthCGFloat = view.bounds.size.height
        
        NSLayoutConstraint.activate([
            inputLinkTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputLinkTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            inputLinkTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            inputLinkTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: inputLinkTextField.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: totalHeightCGFloat * 0.20 * -1)
            ])
        
        submitButton.layoutIfNeeded()
        submitButton.layer.cornerRadius = 0.1 * submitButton.bounds.size.width
        
    }
    
    //MARK:- Handlers
    @objc func handleSubmitButton(){
        print("HI")
    }
    
    
    
    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
}
