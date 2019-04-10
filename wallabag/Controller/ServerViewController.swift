//
//  ServerViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagCommon
import WallabagKit

final class ServerViewController: UIViewController {
    var analytics: AnalyticsManagerProtocol!
    var setting: SettingProtocol!

    @IBOutlet var server: UITextField!
    @IBOutlet var nextButton: UIButton!

    override func viewDidLoad() {
        analytics.sendScreenViewed(.serverView)
        server.text = setting.get(for: .host)
    }

    @IBAction func nextPressed(_ sender: UIButton) {
        sender.isEnabled = false
        setting.set(server.text!, for: .host)
        validateServer(string: server.text!) { [unowned self] isValid in
            sender.isEnabled = true
            if isValid {
                self.performSegue(withIdentifier: "toClientId", sender: nil)
            } else {
                let alertController = UIAlertController(
                    title: "Error".localized,
                    message: "Whoops looks like something went wrong. Check the url, don't forget http or https".localized,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                print("tesaeaeaeaet")
                self.present(alertController, animated: false, completion: nil)
            }
        }
    }

    private func validateServer(string: String, completion: @escaping (Bool) -> Void) {
        do {
            let regex = try NSRegularExpression(pattern: "(http|https)://", options: [])
            guard let url = URL(string: string),
                UIApplication.shared.canOpenURL(url),
                1 == regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).count else {
                completion(false)
                return
            }
            completion(true)
            /* WallabagKit.getVersion(from: string) { version in
                 Log("Server version \(version)")
                 completion(version.supportedVersion != .unsupported)
             } */
        } catch {
            completion(false)
        }
    }
}
