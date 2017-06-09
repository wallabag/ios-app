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

    @IBAction func login(_ sender: UIButton) {
        sender.isEnabled = false

        WallabagApi.requestToken(username: username.text!, password: password.text!) { success, error in
            if success {
                self.performSegue(withIdentifier: "toArticles", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error".localized, message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                self.present(alert, animated: false)
            }

            sender.isEnabled = true
        }
    }
}
