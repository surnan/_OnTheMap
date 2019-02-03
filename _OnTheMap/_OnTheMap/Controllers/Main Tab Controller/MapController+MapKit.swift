//
//  MapController+MapKit.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension MapController: MKMapViewDelegate {

    func setupMap(){
        loadLocationsArray()
        convertLocationsToAnnotations()
        self.mapView.addAnnotations(annotations)  //There's a singular & plural for 'addAnnotation'.  OMG
    }
    
    func convertLocationsToAnnotations(){
        
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary["firstName"] as! String
            let last = dictionary["lastName"] as! String
            let mediaURL = dictionary["mediaURL"] as! String
            
            
            let tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = coordinate
            tempAnnotation.title = "\(first) \(last)"
            tempAnnotation.subtitle = mediaURL

            annotations.append(tempAnnotation)
        }
        
        
    }
    
    func loadLocationsArray(){
        Students.uniques.forEach {
            let temp: [String:Any] = [
                "objectId": $0.objectId ?? "",
                "uniqueKey": $0.uniqueKey ?? "",
                "firstName": $0.firstName ?? "",
                "lastName": $0.lastName ?? "",
                "mapString": $0.mapString ?? "",
                "mediaURL": $0.mediaURL ?? "",
                "latitude": $0.latitude ?? 0,
                "longitude": $0.longitude ?? 0,
                "createdAt": $0.createdAt ?? "",
                "updatedAt": $0.updatedAt ?? ""
            ]
            locations.append(temp)
        }
    }
    
}
