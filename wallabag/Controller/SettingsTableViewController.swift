//
//  ParameterTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import AVFoundation

final class SettingsTableViewController: UITableViewController {

    let analytics = AnalyticsManager()

    @IBOutlet weak var currentThemeLabel: UILabel!
    @IBOutlet weak var justifySwitch: UISwitch!
    @IBOutlet weak var badgeSwitch: UISwitch!
    @IBOutlet weak var speechRateSlider: UISlider!

    @IBAction func speechRateChanged(_ sender: UISlider) {
        Setting.setSpeechRate(value: sender.value)
    }

    @IBAction func justifySwitch(_ sender: UISwitch) {
        Setting.setJustifyArticle(value: sender.isOn)
    }

    @IBAction func badgeSwitch(_ sender: UISwitch) {
        Setting.setBadgeEnable(value: sender.isOn)
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.settingView)
        super.viewDidLoad()

        prepareDefaultList()

        justifySwitch.setOn(Setting.isJustifyArticle(), animated: false)
        badgeSwitch.setOn(Setting.isBadgeEnable(), animated: false)
        currentThemeLabel.text = Setting.getTheme().ucFirst

        speechRateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        speechRateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        speechRateSlider.value = Setting.getSpeechRate()

        _ = NotificationCenter.default.addObserver(forName: Notification.Name.themeUpdated, object: nil, queue: nil) { _ in
            self.tableView.reloadData()
            self.currentThemeLabel.text = Setting.getTheme().ucFirst
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            for row in 0 ... tableView.numberOfRows(inSection: indexPath.section) {
                tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
            }

            if let cell = tableView.cellForRow(at: indexPath) {
                Setting.setDefaultMode(mode: Setting.RetrieveMode(rawValue: cell.reuseIdentifier!)!)
                cell.accessoryType = .checkmark
            }

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = ThemeManager.manager.getBackgroundSelectedColor()
            header.textLabel?.textColor = ThemeManager.manager.getColor()
        }
    }

    private func prepareDefaultList() {
        for row in 0 ... tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                if Setting.RetrieveMode(rawValue: cell.reuseIdentifier!)! == Setting.getDefaultMode() {
                    cell.accessoryType = .checkmark
                }
            }
        }
    }
}
