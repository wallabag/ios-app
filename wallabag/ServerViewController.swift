//
//  ServerViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ServerViewController: UIViewController {

    @IBOutlet weak var server: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        server.text = "http://www.annonces-airsoft.fr:8080"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ClientIdViewController {
            controller.server = server.text!
        }
    }
}
