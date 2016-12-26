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
        view.backgroundColor = Setting.getTheme().backgroundColor

        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

        versionText.text = String(format: "Version %@ build %@", arguments: [version, build])
    }

}
