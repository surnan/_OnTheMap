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

class EditStudentLocationController: UIViewController, MKMapViewDelegate {
    
    var field: UITextField?
    
    var delegate: AddLocationControllerDelegate?
    private var mapView = MKMapView()
    
    var mapString = ""
    var mediaURL = ""
    var location = CLLocation()
    var coord = CLLocationCoordinate2D()
    
    
    private let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.steelBlue
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.setAttributedTitle(NSAttributedString(string: "  FINISH  ", attributes: white25textAttributes), for: .normal)
        button.addTarget(self, action: #selector(handleFinishButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        mapView.delegate = self
        navigationItem.title = "Add Location"
        [mapView, finishButton].forEach{view.addSubview($0)}
        mapView.fillSuperview()
        finishButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: mapView.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .zero)
        
        let annotation = MKPointAnnotation()
        
        if let coordinate = delegate?.getPutPostInfo()?.location.coordinate{
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.mapType = .standard
            mapView.setCenter(coordinate, animated: true)
        } else {
            print("Unable to obtain coordinate from delegate")
        }
    }
    
    
    
    @objc func handleFinishButton(){
            print("HI")
        
        guard let pushPostObject = delegate?.getPutPostInfo() else {
            return
        }
        
        
        if let objectID = pushPostObject.object {
            //PUT
            print("NEED TO PUT")
            ParseClient.putStudentLocation(objectID: objectID,
                                           firstname: pushPostObject.firstName,
                                           lastName: pushPostObject.lastName,
                                           mapString: pushPostObject.mapString,
                                           mediaURL: pushPostObject.urlString,
                                           latitude: pushPostObject.location.coordinate.latitude,
                                           longitude: pushPostObject.location.coordinate.longitude,
                                           completion: handlePutStudentLocation)
        } else {
            //POST
            ParseClient.postStudentLocation(firstname: pushPostObject.firstName,
                                            lastName: pushPostObject.lastName,
                                            mapString: pushPostObject.mapString,
                                            mediaURL: pushPostObject.urlString,
                                            latitude: pushPostObject.location.coordinate.latitude,
                                            longitude: pushPostObject.location.coordinate.longitude,
                                            completion: handlePostStudentLocation)
        }
    }
    
//    func handlePutStudentLocation(data: postStudentLocationResponse?, err: Error?){
    func handlePutStudentLocation(success: Bool, err: Error?){
        let  vc =  navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
        //let  vc =  self?.navigationController?.viewControllers[1]
        navigationController?.popToViewController(vc!, animated: true)
    }
    
    
    
    
    func handlePostStudentLocation(data: postStudentLocationResponse?, error: Error?){
//    func handlePostStudentLocation(success: Bool, error: Error?){
        let  vc =  navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
        //let  vc =  self?.navigationController?.viewControllers[1]
        navigationController?.popToViewController(vc!, animated: true)
    }
}
