//
//  AddLocationController+validateFunc.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

extension AddLocationController {
    
    func isStringToURLValid(testString: String)-> String?{
        if testString._isValidURL {
            return testString._prependHTTPifNeeded()
        } else {
            let alertController = UIAlertController(title: "Invalid URL", message: "Unable to convert entry to valid URL", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true)
            return nil
        }
    }
    
    func isStringToLocationValid(testString: String, completion: @escaping (Bool, Error?)-> Void){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(testString) { [unowned self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            DispatchQueue.main.async {
                self.globalLocation = location
                completion(true, nil)
            }
            return
        }
    }
}
