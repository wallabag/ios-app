//
//  ParameterTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var justifySwitch: UISwitch!
    @IBAction func justifySwitch(_ sender: UISwitch) {
        Setting.setJustifyArticle(value: sender.isOn)
    }

    @IBOutlet weak var nigthSwitch: UISwitch!
    @IBAction func nightSwitch(_ sender: UISwitch) {
        let theme: ThemeManager.Theme = sender.isOn ? .night : .light
        if sender.isOn {
            Setting.setTheme(value: theme)
        } else {
            Setting.setTheme(value: theme)
        }

        Setting.setTheme(value: theme)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareDefaultList()

        justifySwitch.setOn(Setting.isJustifyArticle(), animated: false)
        nigthSwitch.setOn(Setting.getTheme() == .night, animated: false)

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
