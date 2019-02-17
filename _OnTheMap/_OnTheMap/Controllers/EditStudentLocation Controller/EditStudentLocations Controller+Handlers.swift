//
//  VerifyOnMap+Handlers.swift
//  _OnTheMap
//
//  Created by admin on 2/12/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


//var mapString = ""
//var mediaURL = ""
//var location = CLLocation()
//var coord = CLLocationCoordinate2D()

//extension EditStudentLocationController {
//    @objc func handleFinish(){
//
//        let storedObjectID = UserDefaults.standard.object(forKey: studentLocationKey) as? String
//        
//        if storedObjectID == nil {
//            print("GOING TO POST")
//            
////            ParseClient.postStudentLocation(firstname: <#T##String#>, lastName: <#T##String#>, mapString: <#T##String#>, mediaURL: <#T##String#>, latitude: <#T##Double#>, longitude: <#T##Double#>, completion: <#T##(postStudentLocationResponse?, Error?) -> Void#>)
//            
//            
//        } else {
//            print("PUT PUT PUT")
//        }
//    }
//}
    
    
//UserDefaults.standard.removeObject(forKey: key)
//UserDefaults.standard.set(postStudentLocationResponseObject.objectId, forKey: key)
//let storedObjectID = UserDefaults.standard.object(forKey: key) as? String

    
    
    
    /*
    
    private func getFirstLastNames(potentialName: String?){
        guard let testString = potentialName else {return}
        
        if let index = testString.firstIndex(of: " ") {
            var firstName = testString.prefix(through: index)
            var lastName = testString.suffix(from: index)
            firstName.removeLast()
            lastName.removeFirst()
            print("good news. Name = \(firstName)  \(lastName)")
            ParseClient.postStudentLocation(firstname: String(firstName), lastName: String(lastName), mapString: mapString, mediaURL: mediaURL._prependHTTPifNeeded(), latitude: coord.latitude, longitude: coord.longitude, completion: handlePostStudentLocation(item:error:))
        } else {
            print("User ented invalid String without space.  Not a valid name")
            let anotherAlertController = UIAlertController(title: "Invalid Name Entry", message: "At least one space is needed to differentiate first and last names", preferredStyle: .alert)
            anotherAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(anotherAlertController, animated: true)
        }
    }
    
    
    private func pushOrPost(){
        guard let delegate = delegate else {
            print("Delegate is UNDEFINED!!.  No pointer back to VerifyOnMapController")
            return
        }
        
        mapString = delegate.getMapString()
        mediaURL = delegate.getURLString()
        location = delegate.getLoction()
        coord = location.coordinate
        
        
        let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
        if storedObjectID == nil {
            
            let myAlerController = UIAlertController(title: "New Student Location", message: "Please enter full name for new student location.  First space will be used to separate first and last names", preferredStyle: .alert)
            myAlerController.addTextField { [weak self](input) in
                input.placeholder = "Please Enter Full Name"
                input.clearButtonMode = UITextField.ViewMode.whileEditing
                input.autocapitalizationType = .words
                self?.field = input
                print("field = \(self?.field?.text ?? "")  && input = \(input.text ?? "")"  )
            }
            
            func yesHandler(actionTarget: UIAlertAction){
                _ = getFirstLastNames(potentialName: field?.text)
            }
            
            myAlerController.addAction(UIAlertAction(title: "Save", style: .default, handler: yesHandler))
            myAlerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(myAlerController, animated: true)
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
                                              mediaURL: mediaURL._prependHTTPifNeeded(),
                                              latitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude)
            ParseClient.changingStudentLocation(objectID: (object.objectId), encodable: putRequestObject) { [weak self](_, _) in
                
                let  vc =  self?.navigationController?.viewControllers.filter({$0 is MainTabBarController}).first
                //        let  vc =  self?.navigationController?.viewControllers[1]
                self?.navigationController?.popToViewController(vc!, animated: true)
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
        print("handleDelete was run.  NSUserDefaults object deleted")
        UserDefaults.standard.removeObject(forKey: key)
    }
}
*/