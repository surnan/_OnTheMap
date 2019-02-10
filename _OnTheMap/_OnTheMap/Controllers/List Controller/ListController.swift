//
//  File2.swift
//  _OnTheMap
//
//  Created by admin on 2/1/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ListController:UITableViewController{
    
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
        
    }
}
