//
//  AddLocationConttroller+Handle.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation



extension AddLocationController {

    @objc func handleFindLocation(_ sender: UIButton){
        guard let temp = isStringToURLValid(testString: urlTextField.text ?? "") else {return}
        mediaURL = temp
        showPassThroughNetworkActivityView()
        sender.isSelected = true
        geoCoder.cancelGeocode()
        
        print("running a search")
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [weak self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                self?.showFinishNetworkRequest()
                sender.isSelected = false
                self?.showOKAlert(title: "Location Error", message: "Unable to find location on map")
                return
            }
            self?.globalLocation = location
            DispatchQueue.main.async {
                let newVC = EditStudentLocationController()
                newVC.delegate = self
                self?.navigationController?.pushViewController(newVC, animated: true)
            }
        }
    }
    
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
}
