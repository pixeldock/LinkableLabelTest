//
//  LinkableTableViewCell.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit

class LinkableTableViewCell: UITableViewCell {
    
    let dummyImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let dummyAccessoryView = UIView()
    
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
        dummyImageView.backgroundColor = .yellow
        contentView.addSubview(dummyImageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)
        
        dummyAccessoryView.backgroundColor = .lightGray
        dummyAccessoryView.layer.cornerRadius = 10
        dummyAccessoryView.clipsToBounds = true
        contentView.addSubview(dummyAccessoryView)
        
        linkableLabel.numberOfLines = 0
        contentView.addSubview(linkableLabel)
    }
    
    func setupLayout() {
        dummyImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dummyAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        linkableLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummyImageView.widthAnchor.constraint(equalToConstant: 60),
            dummyImageView.heightAnchor.constraint(equalToConstant: 60),
            dummyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            dummyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: dummyImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dummyImageView.trailingAnchor, constant: 20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dummyAccessoryView.topAnchor.constraint(equalTo: dummyImageView.topAnchor),
            dummyAccessoryView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            dummyAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dummyAccessoryView.widthAnchor.constraint(equalToConstant: 20),
            dummyAccessoryView.heightAnchor.constraint(equalToConstant: 20),
            
            linkableLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            linkableLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            linkableLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            linkableLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
    }

}
