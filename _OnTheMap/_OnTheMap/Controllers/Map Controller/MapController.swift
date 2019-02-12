//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController:UIViewController, MKMapViewDelegate{
    
    //MARK:- Declarations for MapController+MapKit
    var locations = [[String:Any]]()
    var annotations = [MKPointAnnotation]()
    
    //MARK:- File Specific
    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    var secretMapView: MKMapView = {
        var mapView = MKMapView()
        mapView.alpha = 0.5
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    //MARK:- Swift VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        view.backgroundColor = UIColor.black

        setupMap()
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.all = data
                Students.loadPins()
                self.setupMap()
            } else {
                print("OH BOY")
            }
        }
        
        
        setupUI()
        
    }
    
    func setupUI(){
        view.addSubview(mapView)
//        view.addSubview(secretMapView)
//        mapView.isHidden = true
//        secretMapView.isHidden = false
        NSLayoutConstraint.activate([
//            secretMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            secretMapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            secretMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            secretMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
}
