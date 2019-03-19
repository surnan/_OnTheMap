//
//  AddLocation+Override.swift
//  _OnTheMap
//
//  Created by admin on 2/17/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

extension AddLocationController {
    
    private func setupNavigationPane(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "Add Location"
    }
    
    @objc private func handleCancel(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        urlTextField.delegate = self
        locationTextField.delegate = self
        setupNavigationPane()
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fill
            stack.spacing = 15
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        [locationTextField, urlTextField, findLocationButton].forEach{
            $0.heightAnchor.constraint(equalToConstant: customUIHeightSize).isActive = true
            stackView.addArrangedSubview($0)
        }
        
        [stackView, locationImageView].forEach{view.addSubview($0)}
        NSLayoutConstraint.activate([
            locationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            locationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: locationImageView.bottomAnchor, constant: 50),
            locationTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            urlTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            findLocationButton.widthAnchor.constraint(equalTo: locationTextField.widthAnchor),
            ])
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showFinishNetworkRequest()
        findLocationButton.isSelected = false
    }
}
