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
    
    override func viewDidLoad() {
        mapView.delegate = self
        inputLinkTextField.delegate = self
        [mapView, inputLinkTextField].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            inputLinkTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            inputLinkTextField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            inputLinkTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            inputLinkTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            mapView.topAnchor.constraint(equalTo: inputLinkTextField.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
    
    
    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
}
