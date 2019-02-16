//
//  MainTabController.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit


class MainTabBarController: UITabBarController{
    private var currentSearchTask: URLSessionTask?
    
    var currentObject:  VerifiedPostedStudentInfoResponse?
    
    var willOverwrite = false
    
    private var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        self.setupBottomToolBar()                   //Make toolbar visible before network call
        self.setupTopToolBar()                      //Update the NavigationPane from LoginController
        if currentSearchTask != nil {
            currentSearchTask?.cancel()
            print("Cancelled search Request")
        }
        showPassThroughNetworkActivityView()
        currentSearchTask = ParseClient.getStudents(completion: handleGetStudents(data:err:))
    }
    
    
    //MARK:- Toolbar Setup
    private func setupBottomToolBar(){
        let mapIcon = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "icon_mapview-selected"), selectedImage: #imageLiteral(resourceName: "icon_mapview-deselected"))
        let listIcon = UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "icon_listview-selected"), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected"))
        let mapController = MapController()
        let listController = AnnotationTableController()
        mapController.tabBarItem = mapIcon
        listController.tabBarItem = listIcon
        let controllers = [mapController, listController]
        self.viewControllers = controllers
    }
    
    private func setupTopToolBar(){
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .done, target: self, action: #selector(handleAddBarButton)),
                                              UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .done, target: self, action: #selector(handleRefreshBarButton)),
        ]
    }
    
    
    //MARK:- Handlers
    @objc private func handleLogout(){
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        FBSDKLoginManager().logOut()
        UdacityClient.logout {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func handleAddBarButton(){
        func doSomething(alert: UIAlertAction!){
            let newVC = AddLocationController()
            self.navigationController?.pushViewController(newVC, animated: true)
        }

        if willOverwrite {
            let newVC = AddLocationController()
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let myAlertController = UIAlertController(title: "Overwrite", message: "Overwrite existing location?", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: doSomething))
            myAlertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            present(myAlertController, animated: true)
        }
    }
    
    @objc private func handleRefreshBarButton(){
        ActivityIndicatorSingleton.shared.mapDelegate?.startActivityIndicator()
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.startActivityIndicator()
        if currentSearchTask != nil {
            currentSearchTask?.cancel()
            print("Cancelled search Request")
        }
        currentSearchTask = ParseClient.getStudents { [weak self] (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self?.setupBottomToolBar() //let mapController = MapController()
                ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
                ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
            } else {
                self?.showOKAlert(title: "Loading Error", message: "Unable to download Student Locations")
                print("handleRefresh unable failed ParseClient.getStudents")
            }
        }
    }
    
    func handleGetStudents(data: [PostedStudentInfoResponse], err: Error?){
        
        setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
        ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
        showFinishNetworkRequest()
        
        if err != nil {
            showOKAlert(title: "Loading Error", message: "Unable to Update Student Locations")
            print("handleGetStudentsm --> Err --> \(String(describing: err))")
            return
        }
        
        Students.allStudentLocations = data
        Students.loadValidLocations()  //[VerifiedStudentLocations]
        
        
//        let matchingValidLocation = Students.validLocations.filter{$0.uniqueKey == UdacityClient.getAccountKey()}.first
        let matchingValidLocation = Students.validLocations.filter{$0.uniqueKey == "9361191001"}.first
        
        
        if matchingValidLocation != nil {
            print("found a match")
            
            ParseClient.getStudentLocation(key: UdacityClient.getAccountKey(), completion: handleGetStudent)
            
            willOverwrite = true
        } else {
            print("did not find a match")
            willOverwrite = false
        }
    }
    
    
    func handleGetStudent(studentLocationResponse: GetStudentLocationResponse?, err: Error?){
        guard let object = studentLocationResponse else {
            print("There was an error")
            return
        }
        print(object.firstName)
        print(object.lastName)
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

 /*
 //////
 var searchKey = "4931429520"
 searchKey = UdacityClient.getAccountKey()  //From my login
 
 let matchingObject = Students.validLocations.filter{$0.uniqueKey == searchKey}.first
 
 if let searchResultObject = matchingObject {
 print("Found a match")
 print("searchResultObject.firstName ==> \(searchResultObject.firstName)")
 print("searchResultObject.lastName ===> \(searchResultObject.lastName)")
 print("searchResultObject.uniqueKey ===> \(searchResultObject.uniqueKey)")
 } else {
 print("NO MATCH")
 UdacityClient.getPublicUserData(key: searchKey, completion: handleGetPublicUserData(object:error:))
 }
 */

/*
 UserDefaults.standard.removeObject(forKey: key)
 UserDefaults.standard.set(postStudentLocationResponseObject.objectId, forKey: key)
 let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
 */


/*
 func handleGetStudents(data: [PostedStudentInfoResponse], err: Error?){
 if err == nil{
 print("CURRENT SEARCH TASK RUNNING NOW")
 Students.allStudentLocations = data
 Students.loadValidLocations()
 self.setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
 ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
 ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
 self.showFinishNetworkRequest()
 
 //////
 var searchKey = "4931429520"
 searchKey = UdacityClient.getAccountKey()
 self.currentObject = Students.validLocations.filter{$0.uniqueKey == searchKey}.first
 
 if currentObject == nil {
 UserDefaults.standard.set(nil, forKey: studentLocationKey)
 
 UdacityClient.getPublicUserData(key: searchKey, completion: handleGetPublicUserData(object:error:))
 
 
 
 
 } else {
 UserDefaults.standard.set(currentObject?.uniqueKey, forKey: studentLocationKey)
 UserDefaults.standard.set(currentObject?.firstName, forKey: studentLocationFirstName)
 UserDefaults.standard.set(currentObject?.lastName, forKey: studentLocationLastName)
 }
 
 //////
 } else {
 self.showOKAlert(title: "Loading Error", message: "Unable to download Student Locations")
 self.showFinishNetworkRequest()
 self.navigationController?.popViewController(animated: true)
 print("ParseClient not returning expected results\n  \(String(describing: err))")
 }
 }
 
 
 func handleGetPublicUserData(object: UdacityPublicUserData2?, error: Error?){
 guard let object = object else {
 showOKAlert(title: "UNABLE TO GET KEY", message: "UNABLE TO GET KEY")
 return
 }
 
 
 //        let dictionary = object.bigAssDictionary
 //        let firstName = dictionary.firstName
 //        let lastName = dictionary.lastName
 
 
 let firstName = object.firstName
 let lastName = object.lastName
 
 
 UserDefaults.standard.set(currentObject?.uniqueKey, forKey: studentLocationKey)
 UserDefaults.standard.set(firstName, forKey: studentLocationFirstName)
 UserDefaults.standard.set(lastName, forKey: studentLocationLastName)
 print("Saved: \(currentObject?.uniqueKey ?? "") ..... fname = \(firstName) ..... lname = \(lastName)")
 }
 }
 
 
 
 /*
 UserDefaults.standard.removeObject(forKey: key)
 UserDefaults.standard.set(postStudentLocationResponseObject.objectId, forKey: key)
 let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
 */
 */

