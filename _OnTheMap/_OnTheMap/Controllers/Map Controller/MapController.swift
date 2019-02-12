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
    
    
    //MARK:- Declarations for MapController+MapKit
    var locations = [[String:Any]]()
    var annotations = [MKPointAnnotation]()
    
    //MARK:- File Specific
    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    //MARK:- Swift VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMap()
        setupUI()
        view.backgroundColor = UIColor.black
        
    }
    
    func setupUI(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
        view.addSubview(myActivityMonitor)
        myActivityMonitor.center = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BigTest.shared.mapDelegate = self
    }
    
}
