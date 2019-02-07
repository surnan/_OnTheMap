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

class CreateAnnotation:UIViewController, MKMapViewDelegate, UITextFieldDelegate{
    
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
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter a Link to Share Here", attributes: [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.grey196
            ])
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
        
        print("delegate?.getLocation() ==> \(delegate?.getLocation() ?? "")")
        
//        let address = "1 Infinite Loop, Cupertino, CA 95014"
        let address = delegate?.getLocation() ?? ""
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {print("UNABLE to convert to CLL Coordinates");return}
            
//            let coord = location.coordinate
            DispatchQueue.main.async {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                self.mapView.addAnnotation(annotation)
            }
            // Use your location
        }
    }
    
    
    @objc func handleSubmitButton(){
        print("HI HI HI")
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
        print("A")
        return pinView
    }
    
    
    
    
}
