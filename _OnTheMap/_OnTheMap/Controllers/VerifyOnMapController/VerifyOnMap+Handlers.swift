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
    
    func getFirstLastNames(potentialName: String?){
//    func getFirstLastNames(testString: UITextField?)->(String?, String?){
    
        guard let testString = potentialName else {return}
        
        if let index = testString.firstIndex(of: " ") {
            var firstName = testString.prefix(through: index)
            var lastName = testString.suffix(from: index)
            firstName.removeLast()
            lastName.removeFirst()
            print("good news. Name = \(firstName)  \(lastName)")
            //            ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: coord.latitude, longitude: coord.longitude, completion: handlePostStudentLocation(item:error:))
        } else {
            print("Bad news.  Not a valid name")
            
            let anotherAlertController = UIAlertController(title: "Invalid Name Entry", message: "At least one space is needed to differentiate first and last names", preferredStyle: .alert)
            anotherAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(anotherAlertController, animated: true)
        }
    }
    
    
    
//    var field: UITextField?
    
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
            
            let myAlerController = UIAlertController(title: "New Student Location", message: "Please enter full name for new student location.  First space will be used to separate first and last names", preferredStyle: .alert)
            myAlerController.addTextField { (input) in
                input.placeholder = "Please Enter Full Name"
                input.clearButtonMode = UITextField.ViewMode.whileEditing
                self.field = input
                print("field = \(self.field?.text ?? "")  && input = \(input.text ?? "")"  )
            }
            
            func yesHandler(actionTarget: UIAlertAction){
                _ = getFirstLastNames(potentialName: field?.text)
            }
            
            myAlerController.addAction(UIAlertAction(title: "Save", style: .default, handler: yesHandler))
            myAlerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(myAlerController, animated: true)
            
//            ParseClient.postStudentLocation(mapString: mapString, mediaURL: mediaURL, latitude: coord.latitude, longitude: coord.longitude, completion: handlePostStudentLocation(item:error:))
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
