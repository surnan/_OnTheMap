//
//  handleDataModels.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension MainTabBarController {
    func handleGetStudentLocations(data: [StudentLocation], err: Error?){
        
        if err != nil {
            showOKAlert(title: "Loading Error", message: "Unable to Update Student Locations")
            showFinishNetworkRequest()
            print("handleGetStudentsm --> Err --> \(String(describing: err))")
            currentSearchTask = nil
            return
        }
        
        let matchingValidLocation = StudentInformationModel.getVerifiedStudentLocations.filter{$0.uniqueKey == UdacityClient.getAccountKey()}.first
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
        
        StudentInformationModel.loadStudentLocationArrays(studentLocations: data)
        setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
        showFinishNetworkRequest()
        currentSearchTask = nil
    }
    

    
    func handleGetStudent(studentLocationResponse: StudentLocationResultsResponse?, err: Error?){
        guard let objectGetStudentLocationResponse2 = studentLocationResponse else {
            print("There was an error")
            return
        }
        
        let putObject = objectGetStudentLocationResponse2.results.first
        
        firstName = putObject?.firstName ?? ""
        lastName = putObject?.lastName ?? ""
        key = putObject?.uniqueKey ?? ""
        object = putObject?.objectId
    }
    
    
    func handleGetPublicUserData(studentLocationResponse: PublicUserDataResponse?, error: Error?){
        guard let postObject = studentLocationResponse else {
            print("FAIL: handleGetPublicUserData --> \(error ?? "" as! Error)")
            return
        }
        firstName = postObject.firstName ?? ""
        lastName = postObject.lastName ?? ""
        key = postObject.key
    }
}
