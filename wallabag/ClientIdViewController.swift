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

    override func viewDidLoad() {
        super.viewDidLoad()
        clientId.text = "102_1k82ulkibxdwoccgs0cgoowgg0c04wsc8k08kcc0ksk80skcsg"
        clientSecret.text = "5honlishnu8s4s0k4wg4kokg4kkw84kwww4ock8ko4wcw4okk0"

    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? LoginViewController {
            controller.server = server
            controller.clientId = clientId.text!
            controller.clientSecret = clientSecret.text!
        }
    }
}
