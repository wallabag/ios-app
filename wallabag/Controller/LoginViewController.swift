//
//  LoginViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import CoreData

final class LoginViewController: UIViewController {

    var server: String!
    var clientId: String!
    var clientSecret: String!

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        WallabagApi.configureApi(endpoint: server, clientId: clientId, clientSecret: clientSecret, username: username.text!, password: password.text!)

        sender.isEnabled = false

        WallabagApi.requestToken { success in
            if success {
                if let newServer = NSEntityDescription.insertNewObject(forEntityName: "Server", into: CoreData.context) as? Server {

                    newServer.host = self.server
                    newServer.client_id = self.clientId
                    newServer.client_secret = self.clientSecret
                    newServer.username = self.username.text!
                    newServer.password = self.password.text!

                    do {
                        try CoreData.save()
                    } catch {
                        fatalError("Error saving server")
                    }

                    Setting.set(server: newServer)

                    self.performSegue(withIdentifier: "toArticles", sender: nil)
                }
            } else {
                let alert = UIAlertController(title: "Login", message: "Error", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
            }

            sender.isEnabled = true
        }
    }
}
