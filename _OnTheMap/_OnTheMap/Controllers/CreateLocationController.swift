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
    
//    var topView: UIView = {
//       let view = UIView()
//        view.backgroundColor = UIColor.yellow
//       return view
//    }()

    
    var topView: UILabel = {
        let label = UILabel()
        label.text = "Where are you \nstudying \ntoday?"
        label.numberOfLines = -1
        label.textAlignment = .center
        label.backgroundColor = UIColor.yellow
        return label
    }()
    
    
    var midView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    var btmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.green
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
