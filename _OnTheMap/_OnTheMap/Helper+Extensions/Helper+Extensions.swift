//
//  Helpers.swift
//  _OnTheMap
//
//  Created by admin on 2/7/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension String {
    var _isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(startIndex..., in: self)    //startIndex = position of first character in non-empty String
        return detector.firstMatch(in: self, range: range)?.range == range
    }
    
    func _prependHTTPifNeeded() -> String{
        if prefix(4) != "http" {
            return "http://" + self
        } else {
            return self
        }
    }
}

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}

let grey25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.gray,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let black25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.black,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]

let white25textAttributes: [NSAttributedString.Key: Any] = [
    NSAttributedString.Key.foregroundColor : UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "Georgia", size: 25) as Any
]
