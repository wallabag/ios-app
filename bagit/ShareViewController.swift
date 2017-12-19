//
//  ShareViewController.swift
//  bagit
//
//  Created by maxime marinel on 30/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import Social
import WallabagKit

@objc(ShareViewController)
class ShareViewController: UIViewController {

    lazy var extError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "App maybe not configured"])

    lazy var notificationView: UIView = {
        let notification = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        notification.backgroundColor = .white
        notification.layer.cornerRadius = 9.0
        notification.center = self.view.center

        let image = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        image.image = #imageLiteral(resourceName: "wallabag")

        notification.addSubview(image)

        return notification
    }()

    lazy var backView: UIView = {
        let back = UIView(frame: self.view.frame)
        back.backgroundColor = .gray
        back.alpha = 0.6
        return back
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backView)
        view.addSubview(notificationView)
    }

    override func viewWillAppear(_ animated: Bool) {
        if Setting.isWallabagConfigured() {
            guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
                self.extensionContext?.cancelRequest(withError: extError)
                return
            }
            for item in items {
                guard let attachements = item.attachments as? [NSItemProvider] else {
                    self.extensionContext?.cancelRequest(withError: extError)
                    return
                }
                for attachement in attachements {
                    if attachement.hasItemConformingToTypeIdentifier("public.url") {
                        attachement.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, _) -> Void in
                            if let shareURL = url as? NSURL {
                                WallabagApi(host: Setting.getHost()!,
                                            username: Setting.getUsername()!,
                                            password: Setting.getPassword(username: Setting.getUsername()!)!,
                                            clientId: Setting.getClientId()!,
                                            clientSecret: Setting.getClientSecret()!)
                                    .entry(add: shareURL as URL) { result in
                                        switch result {
                                        case .success:
                                            self.clearView()
                                        case .error:
                                            self.clearView(withError: true)
                                        }
                                }
                            } else {
                                self.clearView(withError: true)
                            }
                        })
                    }
                }
            }
        } else {
            self.clearView(withError: true)
        }
    }

    private func clearView(withError: Bool = false) {
        UIView.animate(withDuration: 1.0, animations: {
            self.notificationView.alpha = 0.0
        }, completion: { _ in
            if withError {
                let alertController = UIAlertController(title: "Error", message: "Please open app and try to add manually your url", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
                    self.extensionContext?.cancelRequest(withError: self.extError)
                })
                self.present(alertController, animated: true)
            } else {
                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        })
    }
}
