//
//  MainTabControlller+Handles.swift
//  _OnTheMap
//
//  Created by admin on 2/16/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

extension MainTabBarController{
    @objc   func handleLogout(){
        UdacityClient.logout {
            FBSDKAccessToken.setCurrent(nil)
            FBSDKProfile.setCurrent(nil)
            FBSDKLoginManager().logOut()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc   func handleAddBarButton(){
        if currentlyMakingNetworkRequest() {
            return
        }
        
        func pushViewController(alert: UIAlertAction!){
            let newVC = AddLocationController()
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
        
        if willOverwrite {
            let myAlertController = UIAlertController(title: "Overwrite", message: "Overwrite existing location?", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: pushViewController))
            myAlertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            present(myAlertController, animated: true)
            let newVC = AddLocationController()
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
        } else {
            let newVC = AddLocationController()
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc func handleRefreshBarButton(){
        if currentlyMakingNetworkRequest() {
            return
        }
        
        
        showPassThroughNetworkActivityView()
        currentSearchTask = ParseClient.getStudents { [weak self] (data, err) in
            if err == nil{
                StudentInformationModel.loadStudentLocationArrays(studentLocations: data)
                self?.setupBottomToolBar() //let mapController = MapController()
                self?.showFinishNetworkRequest()
            } else {
                self?.showOKAlert(title: "Loading Error", message: "Unable to download Student Locations")
                self?.showFinishNetworkRequest()
                print("handleRefresh unable failed ParseClient.getStudents")
            }
            self?.currentSearchTask = nil
        }
    }
    
    
    
    func currentlyMakingNetworkRequest()->Bool {
        if currentSearchTask != nil {
            currentSearchTask?.cancel()
            print("Cancelled search Request")
            return true
        } else {
            return false
        }
    }
}



