//
//  AddLocationController+Handlers.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreLocation

extension AddLocationController {
    @objc func handleFindLocation(){
        guard let temp = isStringToURLValid(testString: urlTextField.text ?? "") else {return}
        mediaURL = temp
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationTextField.text ?? "") { [unowned self] (clplacement, error) in
            guard let placemarks = clplacement, let location = placemarks.first?.location else {
                print("UNABLE to convert to CLL Coordinates")
                return
            }
            self.globalLocation = location
            DispatchQueue.main.async {
                let newVC = VerifyOnMapController()
                newVC.delegate = self
                self.navigationController?.pushViewController(newVC, animated: true)
            }
        }
        print("READY FOR NEXT STAGE!!!!!")
    }
}
