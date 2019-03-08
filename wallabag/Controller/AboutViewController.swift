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
    var analytics: AnalyticsManager!
    var themeManager: ThemeManager!

    @IBOutlet var versionText: UILabel!
    @IBAction func reportBug(_: UIButton) {
        let mailController = MFMailComposeViewController()
        mailController.setSubject("Wallabag Feedback")
        mailController.setMessageBody("Please describe your problem or suggest new feature", isHTML: false)
        mailController.setToRecipients(["support@district-web.fr"])

        present(mailController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        analytics.sendScreenViewed(.aboutView)
        view.backgroundColor = themeManager.getBackgroundColor()

        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0"
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"

        versionText.text = String(format: "Version %@ build %@".localized, arguments: [version, build])
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_: MFMailComposeViewController, didFinishWith _: MFMailComposeResult, error _: Error?) {
        dismiss(animated: true)
    }
}
