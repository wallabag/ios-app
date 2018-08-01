//
//  LoginViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit
import WallabagCommon

final class LoginViewController: UIViewController {

    let analytics = AnalyticsManager()
    var kit: WallabagKit!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false

        Setting.set(username: username.text!)
        Setting.set(password: password.text!, username: username.text!)

        if let host = Setting.getHost(),
            let clientId = Setting.getClientId(),
            let clientSecret = Setting.getClientSecret(),
            let username = Setting.getUsername(),
            let password = Setting.getPassword(username: username) {
            kit = WallabagKit(host: host, clientID: clientId, clientSecret: clientSecret)
            kit.requestAuth(username: username, password: password) { response in
                switch response {
                case .success:
                    Setting.set(wallabagConfigured: true)
                    self.performSegue(withIdentifier: "toArticles", sender: nil)
                case .error(let error):
                    Setting.set(wallabagConfigured: false)
                    let alertController = UIAlertController(
                        title: error.error,
                        message: error.description.localized,
                        preferredStyle: .alert
                    )
                    alertController.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
                    self.present(alertController, animated: true, completion: nil)
                    sender.isEnabled = true
                case .invalidParameter, .unexpectedError:
                    break
                }
            }
        } else {
            //error
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "toArticles" == segue.identifier,
            let navController = segue.destination as? UINavigationController,
            let controller = navController.viewControllers.first as? ArticlesTableViewController {
            controller.wallabagkit = kit
            controller.handleRefresh()
        }
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.loginView)
        username.text = Setting.getUsername()
    }
}
