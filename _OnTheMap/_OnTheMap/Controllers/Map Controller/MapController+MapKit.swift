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
    
    private func convertLocationsToAnnotations(){
        for dictionary in locations {
            let latitude = CLLocationDegrees(dictionary[locationsIndex.latitude.rawValue] as! Double)
            let longitude = CLLocationDegrees(dictionary[locationsIndex.longitude.rawValue] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = dictionary[locationsIndex.firstName.rawValue] as! String
            let lastName = dictionary[locationsIndex.lastName.rawValue] as! String
            let mediaURL = dictionary[locationsIndex.mediaURL.rawValue] as! String
            
            let tempAnnotation = MKPointAnnotation()
            tempAnnotation.coordinate = coordinate
            tempAnnotation.title = "\(firstName) \(lastName)"
            tempAnnotation.subtitle = mediaURL
            annotations.append(tempAnnotation)
        }
    }
    
    private func loadLocationsArray(){
        Students.validLocations.forEach {
            let tempAnnotation: [String:Any] = [
                locationsIndex.objectId.rawValue: $0.objectId,
                locationsIndex.uniqueKey.rawValue: $0.uniqueKey,
                locationsIndex.firstName.rawValue: $0.firstName,
                locationsIndex.lastName.rawValue: $0.lastName,
                locationsIndex.mapString.rawValue: $0.mapString,
                locationsIndex.mediaURL.rawValue: $0.mediaURL,
                locationsIndex.latitude.rawValue: $0.latitude,
                locationsIndex.longitude.rawValue: $0.longitude,
                locationsIndex.createdAt.rawValue: $0.createdAt,
                locationsIndex.updatedAt.rawValue: $0.updatedAt
            ]
            locations.append(tempAnnotation)
        }
    }
    
    
    //MARK:- MKMapViewDelegagate -- MAP Specific functions
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView?.clusteringIdentifier = "identifier"
            pinView?.displayPriority = .defaultHigh
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
        print("\n\nAnnotations.Count ---> \(annotations.count)")
        guard var _stringToURL = view.annotation?.subtitle as? String else {
            UIApplication.shared.open(URL(string: "https://www.google.com")!)     //MediaURL = empty.  Load google
            return
        }
        let backupURL = URL(string: "https://www.google.com/search?q=" + _stringToURL)!  //URL is invalid, convert string to google search query
        if _stringToURL._isValidURL {
            _stringToURL = _stringToURL._prependHTTPifNeeded()
            let url = URL(string: _stringToURL) ?? backupURL
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL)
        }
    }
}
