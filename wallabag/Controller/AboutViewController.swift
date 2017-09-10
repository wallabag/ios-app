//
//  AboutViewController.swift
//  wallabag
//
//  Created by maxime marinel on 20/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var versionText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeManager.manager.getBackgroundColor()

        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "0"
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? "0"

        versionText.text = String(format: "Version %@ build %@".localized, arguments: [version, build])
    }

}
