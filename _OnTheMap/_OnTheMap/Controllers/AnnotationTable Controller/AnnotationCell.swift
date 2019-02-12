//
//  ListCell.swift
//  _OnTheMap
//
//  Created by admin on 2/9/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AnnotationCell: UITableViewCell {
    
    let iconSizeConstant: CGFloat = 40
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "icon_pin")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [iconImageView, titleLabel, messageLabel].forEach{addSubview($0)}
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSizeConstant),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSizeConstant),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


