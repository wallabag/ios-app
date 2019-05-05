//
//  AboutViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import MessageUI
import UIKit

final class AboutViewController: UIViewController {
    var analytics: AnalyticsManagerProtocol!
    var themeManager: ThemeManagerProtocol!

    @IBOutlet var versionText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        analytics.sendScreenViewed(.aboutView)
        view.backgroundColor = themeManager.getBackgroundColor()

        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0"
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"

        versionText.text = String(format: "Version %@ build %@".localized, arguments: [version, build])
    }
}
