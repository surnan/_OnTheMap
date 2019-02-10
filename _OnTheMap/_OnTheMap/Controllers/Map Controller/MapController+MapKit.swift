//
//  MapController+MapKit.swift
//  _OnTheMap
//
//  Created by admin on 2/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

extension MapController {

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
        Students.validLocations.forEach {
            let temp: [String:Any] = [
                "objectId": $0.objectId,
                "uniqueKey": $0.uniqueKey,
                "firstName": $0.firstName,
                "lastName": $0.lastName,
                "mapString": $0.mapString,
                "mediaURL": $0.mediaURL,
                "latitude": $0.latitude,
                "longitude": $0.longitude,
                "createdAt": $0.createdAt,
                "updatedAt": $0.updatedAt
            ]
            locations.append(temp)
        }
    }
    
    
    //MARK:- MKMapViewDelegagate -- MAP Specific functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard var _stringToURL = view.annotation?.subtitle as? String else {
            //MediaURL field is empty
            UIApplication.shared.open(URL(string: "https://www.google.com")!)
            return
        }
        let backupURL = URL(string: "https://www.google.com/search?q=" + _stringToURL)!
        if _stringToURL._isValidURL {
            _stringToURL = _stringToURL._prependHTTPifNeeded()
            let url = URL(string: _stringToURL) ?? backupURL
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL)
        }
    }
}
