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
    
    var mapView: MKMapView = {
       var mapView = MKMapView()
     
        
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    
    //MARK:- Swift VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        ParseClient.getAllStudents { (data, error) in
            guard let dataObject = data else {return}
            let allStudents = dataObject.results
            allStudents.forEach{
                print("name = \($0.firstName ?? "") \($0.lastName ?? "")....latitude =\($0.latitude ?? 0)   longitude \($0.longitude ?? 0)")
            }
        }
        setupUI()
    }
    
    
    func handleGetAllStudents(error: Error?){
        
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
    }
}
