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
        cell.titleLabel.text =  "\(item.firstName) \(item.lastName) ..... \(item.objectId)"
        cell.messageLabel.text = item.mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = locations[indexPath.row]
        let swipeAction = UIContextualAction(style: .normal, title: "Change Location"){(_,_,_) in
            print("objectId = \(self.locations[indexPath.row].objectId)")
            print("Location (latitude, longitude) ==> \(item.latitude)  \(item.longitude)")
            let newVC = CreateLocationController()
            self.present(newVC, animated: true)
        }
        swipeAction.image = #imageLiteral(resourceName: "25_png")
        swipeAction.backgroundColor = UIColor.blue
//        let temp = UISwipeActionsConfiguration(actions: [swipeAction])
        return UISwipeActionsConfiguration(actions: [swipeAction])
    }
    
    @objc func handleSwipe(){
        let newVC = CreateLocationController()
        present(newVC, animated: true)
    }
}
