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
    private var rate: Int = 0
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
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            cell.contentView.backgroundColor = .clear
            self.rate = cell.tag
            self.delegate?.setBreatheRate(rate: rate)
        }
    }
}
