//
//  LoginViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit

final class LoginViewController: UIViewController {

    let analytics = AnalyticsManager()
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false

        Setting.set(username: username.text!)
        Setting.set(password: password.text!, username: username.text!)
        Setting.set(wallabagConfigured: true)

        performSegue(withIdentifier: "toArticles", sender: nil)
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.loginView)
        username.text = Setting.getUsername()
    }
}
