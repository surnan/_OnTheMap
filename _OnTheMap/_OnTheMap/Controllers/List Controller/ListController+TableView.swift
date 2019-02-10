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
        let cell = tableView.dequeueReusableCell(withIdentifier: listReuseID, for: indexPath) as! ListCell
        let item = locations[indexPath.row]
        cell.titleLabel.text =  "\(item.firstName ?? "") \(item.lastName ?? "") ..... \(item.objectId ?? "")"
        cell.messageLabel.text = item.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var stringToURL = locations[indexPath.row].mediaURL  else {
            UIApplication.shared.open(URL(string: "https://www.google.com")!)
            return
        }
        let backupURL2 = URL(string: "https://www.google.com/search?q=" + stringToURL)!
        
        if stringToURL._isValidURL {
        stringToURL = stringToURL._prependHTTPifNeeded()
        let url = URL(string: stringToURL) ?? backupURL2
        UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(backupURL2)
        }
    }
    
    

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let temp2 = UIContextualAction(style: .normal, title: "Move"){(_,_,_) in
            print("Hello World")
        }
        temp2.image = #imageLiteral(resourceName: "25_png")
        temp2.backgroundColor = UIColor.blue
        let temp = UISwipeActionsConfiguration(actions: [temp2])
        return temp
    }
    
    @objc func handleSwipe(){
        print("hello")
    }

    
    
    
    
}
