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
        button.addTarget(self, action: #selector(handledDeletePLIST), for: .touchUpInside)
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
            mapView.mapType = .standard
            mapView.setCenter(coordinate, animated: true)
        } else {
            print("Unable to obtain coordinate from delegate")
        }
    }
    
    
    @objc func handleFinish(){
        pushOrPost()
    }
    
    
    func pushOrPost(){
        guard let delegate = delegate else {
            print("Delegate is UNDEFINED!!.  No pointer back to VerifyOnMapController")
            return
        }
        let mapString = delegate.getMapString()
        let mediaURL = delegate.getURLString()
        let location = delegate.getLoction()
        let coord = location.coordinate
        
        let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
        if storedObjectID == nil {
            ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: coord.latitude, longitude: coord.longitude, completion: handlePostStudentLocation(item:error:))
        } else {
            let object_VerifiedPostedStudentInfoResponse = Students.validLocations.filter{$0.objectId == storedObjectID!}.first //find matching objectID stored in NSUserDefaults
            guard let object = object_VerifiedPostedStudentInfoResponse else {
                print("Not able to retreive object_VerifiedPostedStudentInfoResponse")
                return
            }
            let putRequestObject = PutRequest(uniqueKey: object.uniqueKey,
                                   firstName: object.firstName,
                                   lastName: object.lastName,
                                   mapString: mapString,
                                   mediaURL: mediaURL,
                                   latitude: location.coordinate.latitude,
                                   longitude: location.coordinate.longitude)
            ParseClient.changingStudentLocation(objectID: (object.objectId), encodable: putRequestObject) { (_, _) in
                
                let  vc =  self.navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
                //        let  vc =  self.navigationController?.viewControllers[1]
                self.navigationController?.popToViewController(vc!, animated: true)
            }
        }
    }
    
    func handlePostStudentLocation(item: postStudentLocationResponse?, error: Error?){
        if let item = item {
            print("1 - StudentLocation Added")
            DispatchQueue.main.async {
                UserDefaults.standard.set(item.objectId, forKey: self.key)
            }
            
        } else {
            print(error?.localizedDescription as Any)
            print(error ?? "")
        }
        
        DispatchQueue.main.async {
            let  vc =  self.navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
            //        let  vc =  self.navigationController?.viewControllers[1]
            self.navigationController?.popToViewController(vc!, animated: true)

        }
        
        
    }


    @objc func handledDeletePLIST(){
        print("handleDelete -- run")
        UserDefaults.standard.removeObject(forKey: key)
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
