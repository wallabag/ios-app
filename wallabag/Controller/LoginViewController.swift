//
//  LoginViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    var server: String!
    var clientId: String!
    var clientSecret: String!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        let server = Server(host: self.server,
                            client_secret: self.clientSecret,
                            client_id: self.clientId,
                            username: self.username.text!,
                            password: self.password.text!
        )

        WallabagApi.configureApi(from: server)
        sender.isEnabled = false

        WallabagApi.requestToken { success in
            if success {
                Setting.set(server: server)
                self.performSegue(withIdentifier: "toArticles", sender: nil)
            } else {
                let alert = UIAlertController(title: "Login", message: "Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
            }

            sender.isEnabled = true
        }
    }
}
