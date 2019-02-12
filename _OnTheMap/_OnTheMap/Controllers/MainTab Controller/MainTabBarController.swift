//
//  MainTabController.swift
//  OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit


class MainTabBarController: UITabBarController{

    var mapView: MKMapView = {
        var mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var coverView: UIView = {
        var myView = UIView()
        myView.backgroundColor = UIColor.grey125Half
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .white
        self.setupBottomToolBar()                   //Make toolbar visible before network call
        self.setupTopToolBar()                      //Update the NavigationPane from LoginController
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
                ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
                ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
            } else {
                print("ParseClient not returning expected results\n  \(String(describing: err))")
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
//        self.setupBottomToolBar()                   //Make toolbar visible before network call
//        self.setupTopToolBar()                      //Update the NavigationPane from LoginController
//        ParseClient.getStudents { (data, err) in
//            if err == nil{
//                Students.allStudentLocations = data
//                Students.loadValidLocations()
//                self.setupBottomToolBar()   // Get another instance of MapController.  Easier than reloading all annotations
//                ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
//                ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
//            } else {
//                print("ParseClient not returning expected results\n  \(String(describing: err))")
//            }
//        }
    }
    
    func setupBottomToolBar(){
        let mapIcon = UITabBarItem(title: "MAP", image: #imageLiteral(resourceName: "icon_mapview-selected"), selectedImage: #imageLiteral(resourceName: "icon_mapview-deselected"))
        let listIcon = UITabBarItem(title: "LIST", image: #imageLiteral(resourceName: "icon_listview-selected"), selectedImage: #imageLiteral(resourceName: "icon_listview-deselected"))
        let mapController = MapController()
        let listController = AnnotationTableController()
        mapController.tabBarItem = mapIcon
        listController.tabBarItem = listIcon
        let controllers = [mapController, listController]
        self.viewControllers = controllers
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
        let storedObjectID = UserDefaults.standard.object(forKey: key) as? String
        if storedObjectID != nil {
            let myAlertController = UIAlertController(title: "Confrmation Needed", message: "User Location has already been posted. Do you wish to overwrite?", preferredStyle: .alert)
            myAlertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in
                let newVC = AddLocationController()
                self.navigationController?.pushViewController(newVC, animated: true)
            }))
            myAlertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            present(myAlertController, animated: true)
        } else {
            let newVC = AddLocationController()
            navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc func handleRefreshBarButton(){
        ActivityIndicatorSingleton.shared.mapDelegate?.startActivityIndicator()
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.startActivityIndicator()
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.setupBottomToolBar() //let mapController = MapController()
                ActivityIndicatorSingleton.shared.mapDelegate?.stopActivityIndicator()
                ActivityIndicatorSingleton.shared.AnnotationTableDelegate?.stopActivityIndicator()
            } else {
                print("handleRefresh unable failed ParseClient.getStudents")
            }
        }
    }
}
