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
    
    //MARK:- Local Variables
    var mapString = ""
    var mediaURL = ""
    var globalLocation = CLLocation()
    let geoCoder = CLGeocoder()
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        
        textField.myStandardSetup(cornerRadiusSize: cornerRadiusSize, defaulAttributes: black25textAttributes)
        
        
        return textField
    }()
    
    var urlTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a Website", attributes: grey25textAttributes)
        textField.myStandardSetup(cornerRadiusSize: cornerRadiusSize, defaulAttributes: black25textAttributes)
        return textField
    }()
    
    var findLocationButton: UIButton = {
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
    
    let locationImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon_world"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
