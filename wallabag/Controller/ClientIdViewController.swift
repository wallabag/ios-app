//
//  ClientIdViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ClientIdViewController: UIViewController {

    let analytics = AnalyticsManager()
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var clientSecret: UITextField!
    @IBOutlet weak var helpTextView: UITextView!

    @IBAction func openMyInstance(_ sender: Any) {
        UIApplication.shared.open(URL(string: Setting.getHost()! + "/developer")!, options: [:], completionHandler: nil)
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.clientIdView)
        clientId.text = Setting.getClientId()
        clientSecret.text = Setting.getClientSecret()
        helpTextView.text = "Well, now the client_id and client_secret. This token are secret and can be found in your developer page, And create a new client or use an already existing token".localized
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Setting.set(clientId: clientId.text!)
        Setting.set(clientSecret: clientSecret.text!)
    }
}
