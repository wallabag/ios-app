//
//  ServerViewController.swift
//  wallabag
//
//  Created by maxime marinel on 24/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import WallabagKit

final class ServerViewController: UIViewController {

    @IBOutlet weak var server: UITextField!

    override func viewDidLoad() {
        server.text = Setting.getHost()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if validateServer(string: server.text!) {
            Setting.set(host: server.text!)
            return true
        }

        let alertController = UIAlertController(
            title: "Error".localized,
            message: "Whoops looks like something went wrong. Check the url, don't forget http or https".localized,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)

        return false
    }

    private func validateServer(string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        if !UIApplication.shared.canOpenURL(url) { return false }

        do {
            let regex = try NSRegularExpression(pattern: "(http|https)://", options: [])
            return 1 == regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)).count
        } catch {
            return false
        }
    }
}
