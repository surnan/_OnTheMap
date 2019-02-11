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
    var myActivityMonitor: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .whiteLarge
        return activity
    }()
    
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
        setupTempMapView()

        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.navigationController?.navigationBar.isHidden = false
                self.mapView.removeFromSuperview()
                self.coverView.removeFromSuperview()
                self.setupBottomToolBar()
                self.setupTopToolBar()
                self.myActivityMonitor.stopAnimating()
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
//        let newVC = UINavigationController(rootViewController: CreateLocationController())
//        present(newVC, animated: true)
        
        
//        let newVC = UINavigationController(rootViewController: AddLocationController())
//        present(newVC, animated: true)
        
        let newVC = AddLocationController()
        navigationController?.pushViewController(newVC, animated: true)
        
    }
    
    @objc func handleRefreshBarButton(){
        ParseClient.getStudents { (data, err) in
            if err == nil{
                Students.allStudentLocations = data
                Students.loadValidLocations()
                self.setupBottomToolBar()
                self.setupTopToolBar()
                self.myActivityMonitor.stopAnimating()
            } else {
                print("handleRefresh unable failed ParseClient.getStudents")
            }
        }
    }
    
    func setupTempMapView(){
        view.addSubview(mapView)
        view.addSubview(coverView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverView.topAnchor.constraint(equalTo: view.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            coverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        view.addSubview(myActivityMonitor)
        myActivityMonitor.center = view.center
        myActivityMonitor.startAnimating()
    }
}
