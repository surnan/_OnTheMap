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
    
    let customUIHeightSize: CGFloat = 55
    let cornerRadiusSize: CGFloat = 5

    var mapString = ""
    var mediaURL = ""
    var globalLocation = CLLocation()
    
    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.clearButtonMode = .whileEditing
        textField.defaultTextAttributes = black25textAttributes
        textField.attributedText = NSMutableAttributedString(string: "Enter a Location", attributes: grey25textAttributes)
        textField.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        return textField
    }()
    
    lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
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
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        urlTextField.delegate = self
        locationTextField.delegate = self
        
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
    
    
    
    //MARK:- Handlers
    @objc func handleFindLocation(){
        guard let temp = isStringToURLValid(testString: urlTextField.text ?? "") else {return}
        mediaURL = temp
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [unowned self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                return
            }
            self.globalLocation = location
            DispatchQueue.main.async {
                let newVC = VerifyOnMapController()
                newVC.delegate = self
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
        print("READY FOR NEXT STAGE!!!!!")
    }
    
    
    func isStringToURLValid(testString: String)-> String?{
        if testString._isValidURL {
            return testString._prependHTTPifNeeded()
        } else {
            let alertController = UIAlertController(title: "Invalid URL", message: "Unable to convert entry to valid URL", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return nil
        }
    }
    
    func isStringToLocationValid(testString: String, completion: @escaping (Bool, Error?)-> Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(testString) { [unowned self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            DispatchQueue.main.async {
                self.globalLocation = location
                completion(true, nil)
            }
            return
        }
    }
}
