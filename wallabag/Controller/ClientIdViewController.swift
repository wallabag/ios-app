//
//  ClientIdViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit

final class ClientIdViewController: UIViewController {

    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var clientSecret: UITextField!

    override func viewDidLoad() {
        clientId.text = WallabagApi.getClientId()
        clientSecret.text = WallabagApi.getClientSecret()
    }

    @IBAction func openMyInstance(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: WallabagApi.getHost()! + "/developer")!)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LoginViewController {
            WallabagApi.configure(clientId: clientId.text!, clientSecret: clientSecret.text!)
        }
    }
}
