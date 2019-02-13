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
    
    var field: UITextField?
    
    var delegate: AddLocationControllerDelegate?
    var mapView = MKMapView()
    
    let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.layer.cornerRadius = cornerRadiusSize
        button.clipsToBounds = true
        button.setAttributedTitle(NSAttributedString(string: "  FINISH  ", attributes: steelBlue4_25), for: .normal)
        button.addTarget(self, action: #selector(handleFinish), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let deletePLISTButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.lightSteelBlue1
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setAttributedTitle(NSAttributedString(string: "  Delete PLIST  ", attributes: orange_25), for: .normal)
        button.addTarget(self, action: #selector(handledDeletePLIST), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        mapView.delegate = self
        [mapView, finishButton, deletePLISTButton].forEach{view.addSubview($0)}
        mapView.fillSuperview()
        finishButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: mapView.bottomAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .zero)
        deletePLISTButton.anchor(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: finishButton.topAnchor, padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .zero)
        
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
}
