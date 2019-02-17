//
//  File2.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

    class StudentLocationTableController:UITableViewController{
    var locations = [VerifiedStudentLocation]()
    let listReuseID = "asdfasdfasdfasdf"
    
    //MARK:- Swift Functions
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
    func loadLocationsArray(){
        locations = StudentInformationModel.getVerifiedStudentLocations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.grey227
        loadLocationsArray()    //MapController().ViewDidLoad  ==> preloads 'Class Students' and it's the default opening tab
        print("locations.count --> \(locations.count)")        
        tableView.register(StudentLocationCell.self, forCellReuseIdentifier: listReuseID)
        myActivityMonitor.centerToSuperView() 
    }
}
