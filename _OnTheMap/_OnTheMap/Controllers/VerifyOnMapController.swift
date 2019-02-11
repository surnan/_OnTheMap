//
//  VerifyOnMapController.swift
//  _OnTheMap
//
//  Created by admin on 2/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class VerifyOnMapController: UIViewController, MKMapViewDelegate {
    
    let key = "asdfasdfDaKey"  //NSUserDefaults
    var delegate: AddLocationControllerDelegate?
    
    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.steelBlue4
        ]
        button.setAttributedTitle(NSAttributedString(string: "  FINISH  ", attributes: attributes1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        return button
    }()
    
    let deletePLISTButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 25) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.orange
        ]
        button.setAttributedTitle(NSAttributedString(string: "  Delete PLIST  ", attributes: attributes1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        [mapView, finishButton, deletePLISTButton].forEach{view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            finishButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deletePLISTButton.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -20),
            deletePLISTButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deletePLISTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
        
        let annotation = MKPointAnnotation()
        if let coordinate = delegate?.getLoction().coordinate {
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.setCenter(coordinate, animated: true)
        } else {
            print("Unable to obtain coordinate from delegate")
        }
    }
    
    
    @objc func handleFinish(){
        print("Hello World")
        
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handledDeletePLIST(){
        print("handleDelete -- run")
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
    
    func setupTopBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
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
            
            let mapString = delegate?.getMapString()
            let mediaURL = delegate?.getURLString()
            let globalLocation = delegate?.getLoction()
            
            if exists {
                //            let item = Students.uniques.filter{$0.objectId == "HD8uJHTH7o"}.first
                let item = Students.validLocations.filter{$0.objectId == temp2!}.first
                
                let temp = PutRequest(uniqueKey: (item?.uniqueKey)! , firstName: (item?.firstName)!, lastName: (item?.lastName)!, mapString: mapString!, mediaURL: mediaURL!, latitude: globalLocation!.coordinate.latitude, longitude: globalLocation!.coordinate.longitude)
                ParseClient.changingStudentLocation(objectID: (item?.objectId)!, temp: temp) { (data, err) in
                    if err == nil{
                        print("success")
                    } else {
                        print("failure")
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                ParseClient.postStudentLocation(mapString: mapString!, mediaURL: mediaURL!, latitude: globalLocation!.coordinate.latitude, longitude: globalLocation!.coordinate.longitude, completion: handlePostStudentLocation(item:error:))
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
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            print(error?.localizedDescription as Any)
            print(error ?? "")
        }
    }
    
    
    
}
