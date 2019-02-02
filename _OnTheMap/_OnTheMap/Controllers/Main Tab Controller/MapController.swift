//
//  File.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class MapController:UIViewController{
    
    //MARK:- Declarations for MapController+MapKit
    var locations = [String:Any]()
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
        
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.all = data
                Students.loadPins()
            } else {
                print("OH BOY")
            }
        }
        setupUI()
    }
    
    func setupUI(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("\n ---> \(Students.all.count),      \(Students.uniques.count)\n")
    }
}
