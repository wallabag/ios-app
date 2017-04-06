//
//  ShareViewController.swift
//  bagit
//
//  Created by maxime marinel on 30/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import Social

@objc(ShareViewController)
class ShareViewController: UIViewController {

    lazy var notificationView: UIView = {
        let notification = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        notification.backgroundColor = .white
        notification.layer.cornerRadius = 9.0

        let image = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        image.image = #imageLiteral(resourceName: "wallabag")

        notification.addSubview(image)

        return notification
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationView.center = view.center
        view.addSubview(notificationView)
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async { [unowned self] in
            guard let user = UserDefaults(suiteName: "group.wallabag.share_extension"),
                let host = user.value(forKey: "host") as? String,
                let clientId = user.value(forKey: "clientId") as? String,
                let clientSecret = user.value(forKey: "clientSecret") as? String,
                let username = user.value(forKey: "username") as? String,
                let password = user.value(forKey: "password") as? String else {
                    self.extensionContext?.cancelRequest(withError: NSError())
                    return
            }

            for item in (self.extensionContext?.inputItems as? [NSExtensionItem])! {
                for attachements in (item.attachments as? [NSItemProvider])! {
                    if attachements.hasItemConformingToTypeIdentifier("public.url") {
                        attachements.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, _) -> Void in
                            if let shareURL = url as? NSURL {
                                let server = Server(host: host, client_secret: clientSecret, client_id: clientId, username: username, password: password)
                                WallabagApi.configureApi(from: server)
                                WallabagApi.requestToken { _ in
                                    WallabagApi.addArticle(shareURL as URL, completion: { _ in
                                        UIView.animate(withDuration: 0.5, animations: {
                                            self.notificationView.alpha = 0.0
                                        }, completion: { _ in
                                            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                        })
                                    })
                                }
                            } else {
                                self.extensionContext?.cancelRequest(withError: NSError())
                            }
                        })
                    }
                }
            }
        }
    }
}
