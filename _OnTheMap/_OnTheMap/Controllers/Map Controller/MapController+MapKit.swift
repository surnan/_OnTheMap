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

//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let backupURL = URL(string: "https://www.google.com")!
//        guard let currentAnnotation = view.annotation, var stringToURL = currentAnnotation.subtitle else {
//            // currentAnnotation has blank subtitle.  Handle by opening up any website.
//            UIApplication.shared.open(backupURL, options: [:])
//            return
//        }
//        if (stringToURL?.isValidURL)!{
//            stringToURL = stringToURL?.prependHTTPifNeeded()
//            if let url = URL(string: stringToURL!){
//                UIApplication.shared.open(url, options: [:])
//            } else {
//                UIApplication.shared.open(backupURL, options: [:])
//            }
//        }
//    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let backupURL = URL(string: "https://www.google.com")!
        guard var _stringToURL = view.annotation?.subtitle as? String else {
            //MediaURL field is empty
            UIApplication.shared.open(URL(string: "https://www.google.com")!)
            return
        }

        let backupURL2 = URL(string: "https://www.google.com/search?q=" + _stringToURL)!
        if _stringToURL._isValidURL {
            _stringToURL = _stringToURL._prependHTTPifNeeded()
            let url = URL(string: _stringToURL) ?? backupURL2
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL2)
        }
    }
        
        
        
//        if _stringToURL._isValidURL {
//            _stringToURL = _stringToURL._prependHTTPifNeeded()
//            let url = URL(string: _stringToURL) ?? backupURL
//            UIApplication.shared.open(url)
//        } else {
//
//        }
//    }
}

//extension String {
//    var _isValidURL: Bool {
//        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        let range = NSRange(startIndex..., in: self)    //startIndex = position of first character in non-empty String
//        return detector.firstMatch(in: self, range: range)?.range == range
//    }
//
//    func _prependHTTPifNeeded() -> String{
//        if prefix(4) != "http" {
//            return "http://" + self
//        } else {
//            return self
//        }
//    }
//}
