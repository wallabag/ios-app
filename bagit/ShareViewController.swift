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
                    itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) -> Void in
                        if let shareURL = url as? NSURL {
                            WallabagApi.configureApi(endpoint: self.user?.value(forKey: "host") as! String, clientId: self.user?.value(forKey: "clientId") as! String, clientSecret: self.user?.value(forKey: "clientSecret") as! String, username: self.user?.value(forKey: "username") as! String, password: self.user?.value(forKey: "password") as! String)
                            WallabagApi.addArticle(shareURL as URL, completion: { _ in
                                self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                            })
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
