//
//  ListController+TableView.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


extension AnnotationTableController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: listReuseID, for: indexPath) as! AnnotationCell
        let item = locations[indexPath.row]
        cell.titleLabel.text =  "\(item.firstName) \(item.lastName) ..... \(item.uniqueKey)"
        cell.messageLabel.text = item.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = locations[indexPath.row]
        print("item = \(item)")
        print("\nLocations.count ---> \(locations.count)")
        var stringToURL = locations[indexPath.row].mediaURL
        let backupURL = URL(string: "https://www.google.com/search?q=" + stringToURL)!
        if stringToURL._isValidURL {
        stringToURL = stringToURL._prependHTTPifNeeded()
        let url = URL(string: stringToURL) ?? backupURL
        UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL)
        }
    }
}
