//
//  ConfigTableViewController.swift
//  BreathePOC
//
//  Created by Matheus Oliveira on 23/11/20.
//

import UIKit

protocol ConfigDelegate: class {
    func setBreatheRate(rate: Int)
}

class ConfigTableViewController: UITableViewController {
    
    weak var delegate: ConfigDelegate?
    var currentSelection: Int = 7

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "rateCell")
        let rate = indexPath.row + 4
        cell.textLabel?.text = "\(rate) respirações por minuto"
        cell.selectionStyle = .none
        if rate == currentSelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.currentSelection = indexPath.row + 4
            self.delegate?.setBreatheRate(rate: self.currentSelection)
            self.tableView.reloadData()
    }
}
