//
//  ShareViewController.swift
//  bagit
//
//  Created by maxime marinel on 30/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    let user = UserDefaults(suiteName: "group.wallabag.share_extension")

    override func isContentValid() -> Bool {
        return user?.bool(forKey: "serverConfigured") ?? false
    }

    override func didSelectPost() {
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = item.attachments?.first as? NSItemProvider {
                if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, _) -> Void in
                        if let shareURL = url as? NSURL {
                            guard let host = self.user?.value(forKey: "host") as? String,
                                let clientId = self.user?.value(forKey: "clientId") as? String,
                                let clientSecret = self.user?.value(forKey: "clientSecret") as? String,
                                let username = self.user?.value(forKey: "username") as? String,
                                let password = self.user?.value(forKey: "password") as? String
                                else {
                                    return
                            }
                            let server = Server(host: host, client_secret: clientSecret, client_id: clientId, username: username, password: password)
                            WallabagApi.configureApi(from: server)
                            WallabagApi.requestToken { _ in
                                WallabagApi.addArticle(shareURL as URL, completion: { _ in
                                    self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                })
                            }
                        }
                    })
                }
            }
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }
}
