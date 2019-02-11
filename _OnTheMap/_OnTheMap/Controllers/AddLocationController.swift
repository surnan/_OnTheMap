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


class AddLocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    let customUIHeightSize: CGFloat = 55
    let cornerRadiusSize: CGFloat = 5
    let key = "asdfasdfDaKey"  //NSUserDefaults
    
    var mapString = ""
    var mediaURL = ""
    var globalLocation = CLLocation()
    
    lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.clearsOnBeginEditing = true
        textField.defaultTextAttributes = black25textAttributes
        textField.clearButtonMode = .whileEditing
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
        //        button.setAttributedTitle(NSAttributedString(string: "FIND LOCATION", attributes: white25textAttributes), for: .normal)
        button.setTitle("FIND LOCATION", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleFindLocation), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        return button
    }()
    
    lazy var deletePLISTButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.orange
        //        button.setAttributedTitle(NSAttributedString(string: "delete PLIST", attributes: white25textAttributes), for: .normal)
        button.setTitle("DELETE PLIST", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDeletePLIST), for: .touchUpInside)
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
        
        [locationTextField, urlTextField, findLocationButton, deletePLISTButton].forEach{stackView.addArrangedSubview($0)}
        [stackView, locationImageView].forEach{view.addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 50),
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            urlTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            deletePLISTButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor)
            ])
    }
    
    
    
    //MARK:- Handlers
    @objc func handleFindLocation(){
        
        
        guard let temp = isStringToURLValid(testString: urlTextField.text ?? "") else {return}
        
        mediaURL = temp
        isStringToLocationValid(testString: locationTextField.text ?? "", completion: handleIsStringToLocationValid(success:error:))
        
        print("READY FOR NEXT STAGE!!!!!")
        
        
    }
    
    func handleIsStringToLocationValid(success: Bool, error: Error?){
        if success {
            print("GOOD ADDRESS")
            
            let temp2 = UserDefaults.standard.object(forKey: key) as? String
            if temp2 == nil {
                print("temp = nil")
            } else {
                print("temp = NOT nil")
            }
            
            let exists = temp2 != nil
            
            
            
            if exists {
                //            let item = Students.uniques.filter{$0.objectId == "HD8uJHTH7o"}.first
                let item = Students.validLocations.filter{$0.objectId == temp2!}.first
                
                let temp = PutRequest(uniqueKey: (item?.uniqueKey)! , firstName: (item?.firstName)!, lastName: (item?.lastName)!, mapString: mapString, mediaURL: mediaURL, latitude: globalLocation.coordinate.latitude, longitude: globalLocation.coordinate.longitude)
                ParseClient.changingStudentLocation(objectID: (item?.objectId)!, temp: temp) { (data, err) in
                    if err == nil{
                        print("success")
                    } else {
                        print("failure")
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: globalLocation.coordinate.latitude, longitude: globalLocation.coordinate.longitude, completion: handlePostStudentLocation(item:error:))
            }
            
            
        } else {
            print("Error when trying to convert string to valid CLLocation = \(String(describing: error?.localizedDescription))")
            let alertController = UIAlertController(title: "Invalid Location", message: "Unable to find location on map", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
        }
    }
    
    
    func handlePostStudentLocation(item: postStudentLocationResponse?, error: Error?){
        if let item = item {
            print("StudentLocation Added")
            UserDefaults.standard.set(item.objectId, forKey: key)
        } else {
            print(error?.localizedDescription as Any)
            print(error ?? "")
        }
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
    
    @objc func handleDeletePLIST(){
        UserDefaults.standard.removeObject(forKey: key)
        urlTextField.text = ""
        locationTextField.text = ""
    }

    
    
    func getMapString()-> String{
        return locationTextField.text!
    }
    
    func getCLLocation()-> CLLocation{
        return CLLocation()
    }
    
    //MARK:- UITextField Delegate Functions
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.placeholder = nil
//    }
}
