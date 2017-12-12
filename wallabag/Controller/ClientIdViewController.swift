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

    @IBAction func openMyInstance(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: Setting.getHost()! + "/developer")!)
    }

    override func viewDidLoad() {
        clientId.text = Setting.getClientId()
        clientSecret.text = Setting.getClientSecret()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Setting.set(clientId: clientId.text!)
        Setting.set(clientSecret: clientSecret.text!)
    }
}
