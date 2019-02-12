//
//  File2.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


protocol AnnotationTableControllerDelegate {
    func startActivityIndicator()
    func stopActivityIndicator()
}

class AnnotationTableController:UITableViewController, AnnotationTableControllerDelegate{
    
    //MARK:- Protocol Functions
    func startActivityIndicator(){
        myActivityMonitor.startAnimating()
    }
    
    func stopActivityIndicator(){
        myActivityMonitor.stopAnimating()
    }
    
    
    //MARK:- Swift Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ActivityIndicatorSingleton.shared.AnnotationTableDelegate = self
    }
    
    var myActivityMonitor: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.style = .gray
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
        tableView.register(AnnotationCell.self, forCellReuseIdentifier: listReuseID)
        
        view.addSubview(myActivityMonitor)
        myActivityMonitor.centerToSuperView()
    }
    
    //Mark:- Maybe it's time to consider new view & indicator like LoginController
    override func viewWillLayoutSubviews() {
        self.myActivityMonitor.translatesAutoresizingMaskIntoConstraints = true
        self.myActivityMonitor.frame = self.view.bounds
    }
}
