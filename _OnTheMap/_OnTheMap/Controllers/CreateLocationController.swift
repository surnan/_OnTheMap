//
//  CreateLocationController.swift
//  _OnTheMap
//
//  Created by admin on 2/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class CreateLocationController: UIViewController{
    
    var fullScreenStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    
    var topView: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.grey196
        label.numberOfLines = -1
        label.textAlignment = .center
    
        let attributes1: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 30) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.skyBlue4
        ]
    
        let attributes2: [NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font :  UIFont(name: "Arial-BoldMT", size: 30) as Any,
            NSAttributedString.Key.foregroundColor : UIColor.steelBlue4
        ]

        var totalAttributes = NSMutableAttributedString(string:"Where are you", attributes:attributes1)
        totalAttributes.append(NSMutableAttributedString(string:"\nstudying", attributes:attributes2))
        totalAttributes.append(NSMutableAttributedString(string:"\ntoday?", attributes:attributes1))

        label.attributedText = totalAttributes
        return label
    }()
    
    
    var midView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    var btmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grey196
        return view
    }()
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightGray
        loadFullScreenStackView()
        view.addSubview(fullScreenStackView)

        NSLayoutConstraint.activate([
            fullScreenStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fullScreenStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fullScreenStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    
    func loadFullScreenStackView(){
        [topView, midView, btmView].forEach{fullScreenStackView.addArrangedSubview($0)}
    }
    
    func setupTopView(){
        
    }
    
    func setupMidView(){
        
    }
    
    func setupBtmView(){
        
    }
    
}
