//
//  ParameterTableViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import AVFoundation
import UIKit
import WallabagCommon

final class SettingsTableViewController: UITableViewController {
    var analytics: AnalyticsManager!
    var setting: WallabagSetting!
    var themeManager: ThemeManager!

    @IBOutlet var currentThemeLabel: UILabel!
    @IBOutlet var justifySwitch: UISwitch!
    @IBOutlet var badgeSwitch: UISwitch!
    @IBOutlet var speechRateSlider: UISlider!

    @IBAction func speechRateChanged(_ sender: UISlider) {
        setting.set(sender.value, for: .speechRate)
    }

    @IBAction func justifySwitch(_ sender: UISwitch) {
        setting.set(sender.isOn, for: .justifyArticle)
    }

    @IBAction func badgeSwitch(_ sender: UISwitch) {
        setting.set(sender.isOn, for: .badgeEnabled)
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.settingView)
        super.viewDidLoad()

        prepareDefaultList()

        justifySwitch.setOn(setting.get(for: .justifyArticle), animated: false)
        badgeSwitch.setOn(setting.get(for: .badgeEnabled), animated: false)
        currentThemeLabel.text = setting.get(for: .theme).ucFirst

        speechRateSlider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
        speechRateSlider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
        speechRateSlider.value = setting.get(for: .speechRate)

        _ = NotificationCenter.default.addObserver(forName: Notification.Name.themeUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.tableView.reloadData()
            self?.currentThemeLabel.text = self?.setting.get(for: .theme).ucFirst
        }
    }

    /**
     * @todo clean reuseIdentifier
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            for row in 0 ... tableView.numberOfRows(inSection: indexPath.section) {
                tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
            }

            if let cell = tableView.cellForRow(at: indexPath) {
                setting.set(cell.reuseIdentifier!, for: .defaultMode)
                cell.accessoryType = .checkmark
            }

            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_: UITableView, willDisplayHeaderView view: UIView, forSection _: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.backgroundView?.backgroundColor = themeManager.getBackgroundSelectedColor()
            header.textLabel?.textColor = themeManager.getColor()
        }
    }

    private func prepareDefaultList() {
        for row in 0 ... tableView.numberOfRows(inSection: 0) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                if RetrieveMode(rawValue: cell.reuseIdentifier!)?.rawValue == setting.get(for: .defaultMode) {
                    cell.accessoryType = .checkmark
                }
            }
        }
    }
}
