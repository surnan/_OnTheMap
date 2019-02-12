//
//  VerifyOnMap+Handlers.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension VerifyOnMapController {
    @objc func handleFinish(){
        pushOrPost()
    }
    
    
    func pushOrPost(){
        guard let delegate = delegate else {
            print("Delegate is UNDEFINED!!.  No pointer back to VerifyOnMapController")
            return
        }
        let mapString = delegate.getMapString()
        let mediaURL = delegate.getURLString()
        let location = delegate.getLoction()
        let coord = location.coordinate
        
        let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
        if storedObjectID == nil {
            ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: coord.latitude, longitude: coord.longitude, completion: handlePostStudentLocation(item:error:))
        } else {
            
            let object_VerifiedPostedStudentInfoResponse = Students.validLocations.filter{$0.objectId == storedObjectID!}.first //find matching objectID stored in NSUserDefaults
            guard let object = object_VerifiedPostedStudentInfoResponse else {
                print("Not able to retreive object_VerifiedPostedStudentInfoResponse")
                return
            }
            let putRequestObject = PutRequest(uniqueKey: object.uniqueKey,
                                              firstName: object.firstName,
                                              lastName: object.lastName,
                                              mapString: mapString,
                                              mediaURL: mediaURL,
                                              latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude)
            ParseClient.changingStudentLocation(objectID: (object.objectId), encodable: putRequestObject) { (_, _) in
                
                let  vc =  self.navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
                //        let  vc =  self.navigationController?.viewControllers[1]
                self.navigationController?.popToViewController(vc!, animated: true)
            }
        }
    }
    
    func handlePostStudentLocation(item: postStudentLocationResponse?, error: Error?){
        if let postStudentLocationResponseObject = item {
            print("1 - StudentLocation Added")
            UserDefaults.standard.set(postStudentLocationResponseObject.objectId, forKey: key)
        } else {
            print(error?.localizedDescription as Any)
            print(error ?? "")
        }
        let  vc =  self.navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
        //        let  vc =  self.navigationController?.viewControllers[1]
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    
    @objc func handledDeletePLIST(){
        print("handleDelete -- run")
        UserDefaults.standard.removeObject(forKey: key)
    }
}
