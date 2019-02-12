//
//  File2.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


protocol ListControllerDelegate {
    func startActivityIndicator()
    func stopActivityIndicator()
}

class ListController:UITableViewController, ListControllerDelegate{
    
    
    func startActivityIndicator(){
        myActivityMonitor.startAnimating()
    }
    
    func stopActivityIndicator(){
        myActivityMonitor.stopAnimating()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BigTest.shared.listDelegate = self
    }
    
    var myActivityMonitor: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .gray
//        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    var locations = [VerifiedPostedStudentInfoResponse]()
    let listReuseID = "asdfasdfasdfasdf"
    
    func loadLocationsArray(){
        locations = Students.validLocations

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grey227
        loadLocationsArray()    //MapController().ViewDidLoad  ==> preloads 'Class Students' and it's the default opening tab
        print("locations.count --> \(locations.count)")        
        tableView.register(ListCell.self, forCellReuseIdentifier: listReuseID)
        
        view.addSubview(myActivityMonitor)

        myActivityMonitor.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myActivityMonitor.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
//        myActivityMonitor.center = view.center
    }
    
    
    override func viewWillLayoutSubviews() {
        self.myActivityMonitor.translatesAutoresizingMaskIntoConstraints = true
        self.myActivityMonitor.frame = self.view.bounds
    }
}
