//
//  ThemeChoiceTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 22/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ThemeChoiceTableViewController: UITableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThemeManager.Theme.allThemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let theme: ThemeManager.Theme = ThemeManager.Theme.allThemes[indexPath.row]

        cell.textLabel?.text = theme.rawValue.ucFirst

        if theme == Setting.getTheme() {
            cell.accessoryType = .checkmark
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0 ... tableView.numberOfRows(inSection: indexPath.section) {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedTheme = ThemeManager.Theme.allThemes[indexPath.row]

        Setting.setTheme(value: selectedTheme)

        _ = navigationController?.popViewController(animated: true)
    }
}
