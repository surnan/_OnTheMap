//
//  CreateAnnotation.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CreateAnnotationController:UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    
    var delegate: CreateLocationControllerDelegate?
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.clipsToBounds = true
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.steelBlue4
        ]
        button.setAttributedTitle(NSAttributedString(string: "     Submit     ", attributes: attributes1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        return button
    }()
    
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
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.grey196
        ]
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: attributes1)
        textfield.defaultTextAttributes = attributes1
        textfield.textAlignment = .center
        textfield.clearsOnInsertion = true
        textfield.autocapitalizationType = .none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupTopBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        inputLinkTextField.delegate = self
        [mapView, inputLinkTextField, submitButton].forEach{view.addSubview($0)}
        
        setupTopBar()
        
        let bounds = UIScreen.main.bounds
        //        let width = bounds.size.width
        let height = bounds.size.height
        
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
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: height * -1 * 0.15)
            ])
        
        submitButton.layoutIfNeeded()
        submitButton.layer.cornerRadius = 0.075 * submitButton.bounds.size.width
        
        let annotation = MKPointAnnotation()
        if let coordinate = delegate?.getCLLocation().coordinate {
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            mapView.setCenter(coordinate, animated: true)
            
            
        } else {
            print("Unable to obtain coordinate from delegate")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleSubmitButton(){
        guard let mapString = delegate?.getMapString(),
            var mediaURL = inputLinkTextField.text,
            let location = delegate?.getCLLocation() else {
                print("Exit before passing invalid value into UserInfoClient.setupFromAnnotationController")
                return
        }
        mediaURL = mediaURL._prependHTTPifNeeded()
        
       
//        ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, completion: handlePostStudentLocation(success:error:))
         view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)  //including this line & the "dismiss" above will bring us back to the login window
    }
    
    
    
    func handlePostStudentLocation(success: Bool, error: Error?){
        if success {
            print("StudentLocation Added")
        } else {
            print(error?.localizedDescription as Any)
            print(error ?? "")
        }
    }
    
    
    
    
    
    
    
    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .purple
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
