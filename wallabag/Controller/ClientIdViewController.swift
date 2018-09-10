//
//  ClientIdViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagCommon

final class ClientIdViewController: UIViewController {

    let analytics = AnalyticsManager()
    @IBOutlet weak var clientId: UITextField!
    @IBOutlet weak var clientSecret: UITextField!
    @IBOutlet weak var helpTextView: UITextView!
    let setting: Setting = WallabagSetting()

    @IBAction func openMyInstance(_ sender: Any) {
        UIApplication.shared.open(URL(string: setting.get(for: .host) + "/developer")!, options: [:], completionHandler: nil)
    }

    override func viewDidLoad() {
        analytics.sendScreenViewed(.clientIdView)
        clientId.text = setting.get(for: .clientId)
        clientSecret.text = setting.get(for: .clientSecret)
        helpTextView.text = "Well, now the client_id and client_secret. This token are secret and can be found in your developer page, And create a new client or use an already existing token".localized
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setting.set(clientId.text!, for: .clientId)
        setting.set(clientSecret.text!, for: .clientSecret)
    }
}
