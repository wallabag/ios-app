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
        clientId.text = "1_19ayjxe551eswc4gc0sggcc88oks8k04004404kkw84osk8s4k"
        clientSecret.text = "9vwpapc5vawww4s880048go88400kgg0swg4wk8gow00ssowo"

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
