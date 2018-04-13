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

        if let host = Setting.getHost(),
            let clientId = Setting.getClientId(),
            let clientSecret = Setting.getClientSecret(),
            let username = Setting.getUsername(),
            let password = Setting.getPassword(username: username) {
            WallabagKit.instance.host = host
            WallabagKit.instance.clientID = clientId
            WallabagKit.instance.clientSecret = clientSecret
            WallabagKit.instance.requestAuth(username: username, password: password) { response in
                switch response {
                case .success:
                    self.performSegue(withIdentifier: "toArticles", sender: nil)
                default:
                    //error
                    break
                }
            }
        } else {
            //errot
        }
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.loginView)
        username.text = Setting.getUsername()
    }
}
