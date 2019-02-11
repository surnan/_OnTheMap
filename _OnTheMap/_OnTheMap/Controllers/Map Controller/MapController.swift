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
    
    //MARK:- Swift VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupMap()
        setupUI()
//        setupOverlay()
        
        view.backgroundColor = UIColor.black
        mapView.alpha = 0.5
        
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

    
    
    
    
    
//    func setupOverlay(){
//        let worldRect = MKMapRect.world
//        let point1 = MKMapRect.world.origin
//        let point2 = MKMapPoint(x: point1.x + worldRect.size.width, y: point1.y)
//        let point3 = MKMapPoint(x: point2.x, y: point2.y + worldRect.size.height)
//        let point4 = MKMapPoint(x: point1.x, y: point3.y)
//        var points = [point1, point2, point3, point4]
//        let polygon = MKPolygon(points: &points, count: points.count)
//        mapView.addOverlay(polygon)
//    }
    
}
