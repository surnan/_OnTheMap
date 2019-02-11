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
    
    let key = "asdfasdfDaKey"  //NSUserDefaults
    
    
//    var myActivityMonitor: UIActivityIndicatorView = {
//        let activity = UIActivityIndicatorView()
//        activity.hidesWhenStopped = true
//        activity.style = .whiteLarge
//        return activity
//    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.setupBottomToolBar()   //////////////////////////////////////////
        self.setupTopToolBar()      //////////////////////////////////////////
        setupTempMapView()          //////////////////////////////////////////
        
        
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.navigationController?.navigationBar.isHidden = false
                self.mapView.removeFromSuperview()
                self.coverView.removeFromSuperview()
//                self.setupBottomToolBar()
//                self.setupTopToolBar()
                
//                self.myActivityMonitor.stopAnimating()
                BigTest.shared.mapDelegate?.stopActivityIndicator()
                BigTest.shared.listDelegate?.stopActivityIndicator()
                
                
            } else {
                print("ParseClient not returning expected results\n  \(String(describing: err))")
            }
        }
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
        
        BigTest.shared.mapDelegate?.startActivityIndicator()
        BigTest.shared.listDelegate?.startActivityIndicator()

        
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.setupBottomToolBar()
                self.setupTopToolBar()
                
//                self.myActivityMonitor.stopAnimating()
                BigTest.shared.mapDelegate?.stopActivityIndicator()
                BigTest.shared.listDelegate?.stopActivityIndicator()
                
                
            } else {
                print("handleRefresh unable failed ParseClient.getStudents")
            }
        }
    }
    
    func setupTempMapView(){
        view.addSubview(mapView)
        view.addSubview(coverView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverView.topAnchor.constraint(equalTo: view.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
//        view.addSubview(myActivityMonitor)
//        myActivityMonitor.center = view.center
        
        
        
//        myActivityMonitor.startAnimating()
 
        BigTest.shared.mapDelegate?.startActivityIndicator()
        BigTest.shared.listDelegate?.startActivityIndicator()
        
        
        
    }
}


class BigTest{
    static let shared = BigTest()
    var mapDelegate: MapControllerDelegate?
    var listDelegate: ListControllerDelegate?
}
