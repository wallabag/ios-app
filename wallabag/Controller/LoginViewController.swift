//
//  LoginViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagCommon
import WallabagKit

final class LoginViewController: UIViewController {
    var analytics: AnalyticsManagerProtocol!
    var setting: SettingProtocol!
    var wallabagSession: WallabagSession!

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false

        /*let kit = WallabagKit(host: setting.get(for: .host),
                              clientID: setting.get(for: .clientId),
                              clientSecret: setting.get(for: .clientSecret))

        kit.requestAuth(
            username: username.text!,
            password: password.text!
        ) { [unowned self] response in
            defer {
                sender.isEnabled = true
            }
            switch response {
            case .success:
                self.setting.set(true, for: .wallabagIsConfigured)
                self.setting.set(self.username.text!, for: .username)
                self.setting.set(
                    password: self.password.text!,
                    username: self.username.text!
                )
                self.performSegue(withIdentifier: "toArticles", sender: nil)
                self.wallabagSession.kit = kit
            case let .error(error):
                self.setting.set(false, for: .wallabagIsConfigured)
                let alertController = UIAlertController(
                    title: error.error,
                    message: error.description.localized,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            case .invalidParameter, .unexpectedError:
                self.setting.set(false, for: .wallabagIsConfigured)
                let alertController = UIAlertController(
                    title: "Unexpected error",
                    message: "Unexpected error or invalid parameter",
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "ok".localized, style: .cancel))
                self.present(alertController, animated: true, completion: nil)
            }
        }*/
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.loginView)
        username.text = setting.get(for: .username)
    }
}
