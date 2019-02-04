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
    
    let dictionary: [String: Any] = [
        "createdAt" : "2015-02-24T22:27:14.456Z",
        "firstName" : "Jessica",
        "lastName" : "Uelmen",
        "latitude" : 28.1461248,
        "longitude" : -82.75676799999999,
        "mapString" : "Tarpon Springs, FL",
        "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
        "objectId" : "kj18GEaWD8",
        "uniqueKey" : 872458750,
        "updatedAt" : "2015-03-09T22:07:09.593Z"
    ]
    
    
    var annotation = MKPointAnnotation()

    func placePin(){
        let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
        let long = CLLocationDegrees(dictionary["longitude"] as! Double)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = dictionary["firstName"] as! String
        let last = dictionary["lastName"] as! String
        let mediaURL = dictionary["mediaURL"] as! String
        
        
//        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        //        annotations.append(annotation)
        self.mapView.addAnnotation(annotation)
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


    //MARK:- Overloaded Swift Functions
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
        submitButton.isHidden = true
        
        placePin()
        
        mapView.setCenter(annotation.coordinate, animated: true)
 
    }
    
    
    
    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.mapType = .standard
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
    

    //MARK:- Handlers
    @objc func handleSubmitButton(){
        print("HI")
    }
    

    //MARK:- UITextField Delegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
}
