//
//  ClientIdViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ClientIdViewController: UIViewController {

    var server: String!

    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var clientSecret: UITextField!

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LoginViewController {
            controller.server = server
            controller.clientId = clientId.text!
            controller.clientSecret = clientSecret.text!
        }
    }
}
