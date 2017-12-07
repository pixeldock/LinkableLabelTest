//
//  TTTTableViewCell.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TTTTableViewCell: UITableViewCell {
    
    let tttLabel = TTTAttributedLabel(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        tttLabel.numberOfLines = 0
        tttLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        tttLabel.linkAttributes = [NSAttributedStringKey.foregroundColor: UIColor.red]
        contentView.addSubview(tttLabel)
    }
    
    func setupLayout() {
        tttLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tttLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            tttLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tttLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tttLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
    }
    
}
