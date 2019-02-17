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
        //         matchingValidLocation = Students.validLocations.filter{$0.uniqueKey == "213746442237"}.first
        
        
        if let VerifiedPostedStudentInfoResponseObject = matchingValidLocation {
            print(" PUT ---- found a match")
            //            ParseClient.getStudentLocation(key: "3300603272", completion: handleGetStudent)
            ParseClient.getOneStudentLocation(key: VerifiedPostedStudentInfoResponseObject.uniqueKey, completion: handleGetStudent)
            willOverwrite = true
        } else {
            print(" POST ---- did not find a match")
            UdacityClient.getPublicUserData(key: UdacityClient.getAccountKey(), completion: handleGetPublicUserData(studentLocationResponse:error:))
            willOverwrite = false
        }
        currentSearchTask = nil
        
        
        
        
        
        
        
        //        if matchingValidLocation != nil {
        //            print(" PUT ---- found a match")
        ////            ParseClient.getStudentLocation(key: "3300603272", completion: handleGetStudent)
        //            ParseClient.getStudentLocation(key: (matchingValidLocation?.objectId)!, completion: handleGetStudent)
        //            willOverwrite = true
        //        } else {
        //            print(" POST ---- did not find a match")
        //            UdacityClient.getPublicUserData(key: UdacityClient.getAccountKey(), completion: handleGetPublicUserData(studentLocationResponse:error:))
        //            willOverwrite = false
        //        }
        //        currentSearchTask = nil
    }
    

    
    func handleGetStudent(studentLocationResponse: GetStudentLocationResponse2?, err: Error?){
        guard let objectGetStudentLocationResponse2 = studentLocationResponse else {
            print("There was an error")
            return
        }
        
        let putObject = objectGetStudentLocationResponse2.results.first
        
        firstName = putObject?.firstName ?? ""
        lastName = putObject?.lastName ?? ""
        key = putObject?.uniqueKey ?? ""
        object = putObject?.objectId
        
        print("object.firstName ---> \(putObject?.firstName ?? "")")
        print("object.lastName ---> \(putObject?.lastName ?? "")")
        print("object.objectId ---> \(putObject?.objectId ?? "")")
        
        
    }
    
    
    func handleGetPublicUserData(studentLocationResponse: UdacityPublicUserData2?, error: Error?){
        guard let postObject = studentLocationResponse else {
            print("FAIL: handleGetPublicUserData --> \(error ?? "" as! Error)")
            return
        }
        
        
        firstName = postObject.firstName ?? ""
        lastName = postObject.lastName ?? ""
        key = postObject.key
        
        
        print("------------ INSIDE HANDLE ------------")
        print("searchResultObject.firstName ==> \(postObject.firstName ?? "")")
        print("searchResultObject.lastName ===> \(postObject.lastName ?? "")")
        print("searchResultObject.uniqueKey ===> \(postObject.key)")
        
        
        
    }
}
