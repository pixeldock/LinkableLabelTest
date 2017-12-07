//
//  ViewController.swift
//  LinkableLabelTest
//
//  Created by Jörn Schoppe on 07.12.17.
//  Copyright © 2017 Jörn Schoppe. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, LinkableLabelDelegate {
    let numberOfRows = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LinkedLabel"
        view.backgroundColor = .lightGray
        
        tableView.register(LinkableTableViewCell.self, forCellReuseIdentifier: "linkableCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.allowsSelection = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(">>>>>>>>>>> switching to LinkedLabel >>>>>>>>>>>>>")
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkableCell", for: indexPath)
        if let linkableCell = cell as? LinkableTableViewCell {
            linkableCell.titleLabel.text = "This is Row \(indexPath.row)"
            linkableCell.subtitleLabel.text = "This is the subtitle row with some text that breaks into two lines."
            
            linkableCell.linkableLabel.textColor = .black
            linkableCell.linkableLabel.text = Data.texts[indexPath.row]
            linkableCell.linkableLabel.enableLinks()
            linkableCell.linkableLabel.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.texts.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func linkableLabel(_ label: LinkableLabel, didPressLink url: URL) {
        print(url)
    }
}

