//
//  handleDataModels.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension MainTabBarController {
    func handleGetStudents(data: [PostedStudentInfoResponse], err: Error?){
        
        if err != nil {
            showOKAlert(title: "Loading Error", message: "Unable to Update Student Locations")
            print("handleGetStudentsm --> Err --> \(String(describing: err))")
            currentSearchTask = nil
            return
        }
        
        Students.allStudentLocations = data
        Students.loadValidLocations()  //[VerifiedStudentLocations]
        
        setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
        ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
        showFinishNetworkRequest()
        
        
        let matchingValidLocation = Students.validLocations.filter{$0.uniqueKey == UdacityClient.getAccountKey()}.first
        //        let matchingValidLocation = Students.validLocations.filter{$0.uniqueKey == "9361191001"}.first
        
        
        if matchingValidLocation != nil {
            print(" PUT ---- found a match")
            ParseClient.getStudentLocation(key: "3300603272", completion: handleGetStudent)
            willOverwrite = true
        } else {
            print(" POST ---- did not find a match")
            UdacityClient.getPublicUserData(key: UdacityClient.getAccountKey(), completion: handleGetPublicUserData(object:error:))
            willOverwrite = false
        }
        currentSearchTask = nil
    }
    
    func handleGetStudent(studentLocationResponse: GetStudentLocationResponse2?, err: Error?){
        guard let object = studentLocationResponse else {
            print("There was an error")
            return
        }
        
        let object1 = object.results.first
        
        print("object.firstName ---> \(object1?.firstName ?? "")")
        print("object.lastName ---> \(object1?.lastName ?? "")")
        print("object.objectId ---> \(object1?.objectId ?? "")")
    }
    
    
    func handleGetPublicUserData(object: UdacityPublicUserData2?, error: Error?){
        
        guard let object = object else {
            print("FAIL: handleGetPublicUserData --> \(error ?? "" as! Error)")
            return
        }
        
        print("------------ INSIDE HANDLE ------------")
        print("searchResultObject.firstName ==> \(object.firstName ?? "")")
        print("searchResultObject.lastName ===> \(object.lastName ?? "")")
        print("searchResultObject.uniqueKey ===> \(object.key)")
    }
}
