//
//  MainTabController.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol MaintTabBarControllerDelegate {
    func getPutPostInfo()-> (
        object: String?,
        firstName: String,
        lastName: String,
        key: String)
}

class MainTabBarController: UITabBarController, MaintTabBarControllerDelegate{
    var currentSearchTask: URLSessionTask?
    var willOverwrite = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        
        self.setupBottomToolBar()                   //Make toolbar visible before network call
        self.setupTopToolBar()                      //Update the NavigationPane from LoginController
        if currentSearchTask != nil {
            currentSearchTask?.cancel()
            print("Cancelled search Request")
            return
        }
        showPassThroughNetworkActivityView()
        currentSearchTask = ParseClient.getStudents(completion: handleGetStudentLocations(data:err:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK:- Toolbar Setup
    func setupBottomToolBar(){
        let mapIcon = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "icon_mapview-selected"), selectedImage: #imageLiteral(resourceName: "icon_mapview-deselected"))
        let listIcon = UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "icon_listview-selected"), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected"))
        let mapController = StudentLocationMapController()
        let listController = StudentLocationTableController()
        mapController.tabBarItem = mapIcon
        listController.tabBarItem = listIcon
        let controllers = [mapController, listController]
        self.viewControllers = controllers
    }
    
    func setupTopToolBar(){
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .done, target: self, action: #selector(handleAddBarButton)),
                                              UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .done, target: self, action: #selector(handleRefreshBarButton))]
    }
    
    //Protocol Variables
    var firstName = ""
    var lastName = ""
    var key = ""
    var object: String?
    
    func getPutPostInfo() -> (object: String?, firstName: String, lastName: String, key: String) {
        return (object: object,
                firstName: firstName,
                lastName: lastName,
                key: key)
    }
}
