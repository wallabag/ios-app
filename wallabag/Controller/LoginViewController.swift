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

    var clientId: String!
    var clientSecret: String!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        username.text = "wallabag"
        password.text = "wallabag"
    }

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false

        Setting.set(username: username.text!)
        Setting.set(password: password.text!)

        Setting.set(wallabagConfigured: true)

        performSegue(withIdentifier: "toArticles", sender: nil)

        //let session = WallabagSessionManager(host: Setting.getHost()!, username: Setting.getUsername()!, password: Setting.getPassword()!, clientId: Setting.getClientId()!, clientSecret: Setting.getClientSecret()!)


        /*WallabagApi.requestToken(username: username.text!, password: password.text!) { success, error in
            if success {

            } else {
                let alert = UIAlertController(title: "Error".localized, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                self.present(alert, animated: false)
            }

            sender.isEnabled = true
        }*/
    }
}
