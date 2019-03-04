//
//  ThemeChoiceTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 22/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagCommon

final class ThemeChoiceTableViewController: UITableViewController {

    var analytics: AnalyticsManager!
    var setting: WallabagSetting!
    var themeManager: ThemeManager!

    override func viewDidLoad() {
        analytics.sendScreenViewed(.themeChoiceView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themeManager.getThemes().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let theme: ThemeProtocol = themeManager.getThemes()[indexPath.row]

        cell.textLabel?.text = theme.name.ucFirst

        if theme.name == setting.get(for: .theme) {
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

        let selectedTheme = themeManager.getThemes()[indexPath.row]

        setting.set(selectedTheme.name, for: .theme)
        themeManager.apply(selectedTheme.name)

        _ = navigationController?.popViewController(animated: true)
    }
}
