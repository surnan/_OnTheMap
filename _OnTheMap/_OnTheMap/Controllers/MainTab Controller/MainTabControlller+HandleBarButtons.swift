//
//  MainTabControlller+Handles.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
//import FacebookCore
//import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

extension MainTabBarController{
    @objc   func handleLogout(){
//        FBSDKAccessToken.setCurrent(nil)
//        FBSDKProfile.setCurrent(nil)
//        FBSDKLoginManager().logOut()
        UdacityClient.logout {
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            FBSDKLoginManager().logOut()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc   func handleAddBarButton(){
        func pushViewController(alert: UIAlertAction!){
            let newVC = AddLocationController()
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
        if willOverwrite {
            let newVC = AddLocationController()
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let myAlertController = UIAlertController(title: "Overwrite", message: "Overwrite existing location?", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: pushViewController))
            myAlertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            present(myAlertController, animated: true)
        }
    }

    
    @objc   func handleRefreshBarButton(){
        ActivityIndicatorSingleton.shared.mapDelegate?.startActivityIndicator()
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.startActivityIndicator()
        
        if currentSearchTask != nil {
            currentSearchTask?.cancel()
            print("Cancelled search Request")
            return
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
            self?.currentSearchTask = nil
        }
    }
}

