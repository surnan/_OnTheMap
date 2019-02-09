//
//  MainTabController.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.all = data
                Students.loadPins()
                //                self.viewControllers = controllers
                //                self.setupMap()
                self.setupBottomToolBar()
                self.setupTopToolBar()
            } else {
                print("OH BOY")
            }
        }
//        setupBottomToolBar()
//        setupTopToolBar()
    }
    
    func setupBottomToolBar(){
        let mapIcon = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "icon_mapview-selected"), selectedImage: #imageLiteral(resourceName: "icon_mapview-deselected"))
        let listIcon = UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "icon_listview-selected"), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected"))
        let mapController = MapController()
        let listController = ListController()
        mapController.tabBarItem = mapIcon
        listController.tabBarItem = listIcon
        let controllers = [mapController, listController]
        self.viewControllers = controllers
        
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.all = data
                Students.loadPins()
//                self.viewControllers = controllers
//                self.setupMap()
            } else {
                print("OH BOY")
            }
        }
        
        
//        viewControllers = controllers
    }
    
    func setupTopToolBar(){
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), style: .done, target: self, action: #selector(handleAddBarButton)),
                                              UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), style: .done, target: self, action: #selector(handleRefreshBarButton)),
        ]
        
        
    }
    
    @objc func handleLogout(){
        UdacityClient.logout()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddBarButton(){
        let newVC = UINavigationController(rootViewController: CreateLocationController())
        present(newVC, animated: true)
    }
    
    @objc func handleRefreshBarButton(){
        //Right Bar Button
        print("World")
    }
}
