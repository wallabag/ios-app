//
//  HomeViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import CoreData

final class HomeViewController: UIViewController {

    override func viewDidLoad() {

        if let server = CoreData.findAll("Server").first as? Server {
            WallabagApi.configureApi(endpoint: server.host, clientId: server.client_id, clientSecret: server.client_secret, username: server.username, password: server.password)
            WallabagApi.requestToken() { success in
                if success {
                    self.performSegue(withIdentifier: "toArticles", sender: nil)
                }
            }
        }
    }
}
