//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


protocol MapControllerDelegate {
    func startActivityIndicator()
    func stopActivityIndicator()
}

class MapController:UIViewController, MKMapViewDelegate, MapControllerDelegate{
    
    //MARK:- Protocol Functions
    func startActivityIndicator(){
        myActivityMonitor.startAnimating()
        mapView.alpha = 0.5
    }
    
    func stopActivityIndicator(){
        myActivityMonitor.stopAnimating()
        mapView.alpha = 1.0
    }
    

    var myActivityMonitor: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .whiteLarge
        return activity
    }()

    
    //MARK:- Local Variables
    var locations = [[String:Any]]()
    enum locationsIndex:String {
        case objectId
        case uniqueKey
        case firstName
        case lastName
        case mapString
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }
    
    var annotations = [MKPointAnnotation]()
    var mapView = MKMapView()
    
    //MARK:- Swift VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = UIColor.black
        [mapView, myActivityMonitor].forEach{view.addSubview($0)}
        mapView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ActivityIndicatorSingleton.shared.mapDelegate = self
    }
}
