//
//  ListController+TableView.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension ListController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = locations[indexPath.row]
        let cell = UITableViewCell()

        var tempString = ""
        [item.firstName, item.lastName].forEach{
            if let temp = $0 {
                tempString.append("  \(temp)")
            }
        }
    
        cell.textLabel?.text = tempString
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = locations[indexPath.row]
        
        if let url = URL(string: item.mediaURL ?? ""){
            UIApplication.shared.open(url, options: [:])
        } else {
            let backupURL = URL(string: "https://www.google.com")!
            UIApplication.shared.open(backupURL, options: [:])
        }
    }
    
    
}
