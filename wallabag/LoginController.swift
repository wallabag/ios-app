//
//  ViewController.swift
//  wallabag
//
//  Created by maxime marinel on 19/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var endpoint: UITextField!
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var clientSecret: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func login(_ sender: UIButton) {
        WallabagApi.configureApi(endpoint: endpoint.text!, clientId: clientId.text!, clientSecret: clientSecret.text!, username: username.text!, password: password.text!)

        WallabagApi.requestToken() { _ in
            self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        endpoint.text = "http://www.annonces-airsoft.fr:8080"
        clientId.text = "1_19ayjxe551eswc4gc0sggcc88oks8k04004404kkw84osk8s4k"
        clientSecret.text = "9vwpapc5vawww4s880048go88400kgg0swg4wk8gow00ssowo"
        username.text = "wallabag"
        password.text = "wallabag"
    }
}

