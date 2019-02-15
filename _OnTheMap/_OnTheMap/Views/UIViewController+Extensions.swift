//
//  UIViewController+Extensions.swift
//  _OnTheMap
//
//  Created by admin on 2/14/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

let greyPassThroughSuperView: UIView = {
    let _view = UIView()
    _view.backgroundColor = UIColor.grey196Half
    _view.isUserInteractionEnabled = false
    _view.translatesAutoresizingMaskIntoConstraints = false
    return _view
}()

let greyNONPassThroughSuperView: UIView = {
    let _view = UIView()
    _view.backgroundColor = UIColor.grey196Half
    _view.isUserInteractionEnabled = true
    _view.translatesAutoresizingMaskIntoConstraints = false
    return _view
}()


var myActivityMonitor: UIActivityIndicatorView = {
    let activity = UIActivityIndicatorView()
    activity.hidesWhenStopped = true
    activity.style = .whiteLarge
    activity.translatesAutoresizingMaskIntoConstraints = false
    return activity
}()

extension UIViewController {
    func showOKAlert(title: String, message: String){
        let myAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        myAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(myAlertController, animated: true)
    }
    
    
    func showPassThroughNetworkActivityView() {
        [greyPassThroughSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyPassThroughSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
    }
    
    
    func showNONPassThroughNetworkActivityView() {
        [greyNONPassThroughSuperView, myActivityMonitor].forEach{view.addSubview($0)}
        greyNONPassThroughSuperView.fillSuperview()
        myActivityMonitor.centerToSuperView()
        myActivityMonitor.startAnimating()
    }
    
    func showFinishNetworkRequest(){
        greyPassThroughSuperView.removeFromSuperview()
        greyNONPassThroughSuperView.removeFromSuperview()
        myActivityMonitor.stopAnimating()
    }
}
