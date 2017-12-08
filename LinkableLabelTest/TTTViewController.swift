//
//  TTTViewController.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TTTViewController: UITableViewController, TTTAttributedLabelDelegate {
    let numberOfRows = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        tableView.register(TTTTableViewCell.self, forCellReuseIdentifier: "tttCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(">>>>>>>>>>> switching to TTTAttributedLabel >>>>>>>>>>>>>")
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tttCell", for: indexPath)
        if let linkableCell = cell as? TTTTableViewCell {
            linkableCell.titleLabel.text = "This is Row \(indexPath.row)"
            linkableCell.subtitleLabel.text = "This is the subtitle row with some text that breaks into two lines."
            
            let attributedString = NSMutableAttributedString(string: Data.texts[indexPath.row], attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .light),
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray
                ])
            attributedString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 16, weight: .bold), range: NSRange(location: 20, length: 10))
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.patternDot.rawValue, range: NSRange(location: 10, length: 6))
            linkableCell.tttLabel.setText(attributedString)
            linkableCell.tttLabel.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.texts.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let alertView = UIAlertController(title: "Open?", message: "\(url!)" , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { _ in
            UIApplication.shared.openURL(url)
        }
        alertView.addAction(cancelAction)
        alertView.addAction(openAction)
        
        present(alertView, animated: true, completion: nil)
    }
}
