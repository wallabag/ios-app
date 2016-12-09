//
//  ParameterTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {

    @IBAction func justifySwitch(_ sender: UISwitch) {
        Setting.setJustifyArticle(value: sender.isOn)
    }
    @IBOutlet weak var justifySwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDefaultList()

        justifySwitch.setOn(Setting.isJustifyArticle(), animated: false)

        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            for row in 0 ... tableView.numberOfRows(inSection: indexPath.section) {
                tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
            }

            if let cell = tableView.cellForRow(at: indexPath) {
                Setting.setDefaultMode(mode: RetrieveMode(rawValue: cell.reuseIdentifier!)!)
                cell.accessoryType = .checkmark
                cell.selectionStyle = .none
            }
        }
    }

    fileprivate func prepareDefaultList() {
        for row in 0 ... tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                if RetrieveMode(rawValue: cell.reuseIdentifier!)! == Setting.getDefaultMode() {
                    cell.accessoryType = .checkmark
                }
            }
        }
    }
}
