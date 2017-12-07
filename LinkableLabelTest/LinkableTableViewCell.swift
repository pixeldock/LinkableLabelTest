//
//  LinkableTableViewCell.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit

class LinkableTableViewCell: UITableViewCell {
    
    let linkableLabel = LinkableLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        linkableLabel.numberOfLines = 0
        contentView.addSubview(linkableLabel)
    }
    
    func setupLayout() {
        linkableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkableLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            linkableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            linkableLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            linkableLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
    }

}
