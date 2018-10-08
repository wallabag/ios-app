//
//  ShareViewController.swift
//  bagit
//
//  Created by maxime marinel on 30/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import Social
import WallabagCommon
import WallabagKit

@objc(ShareViewController)
class ShareViewController: UIViewController {
    let setting = WallabagSetting()

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
        back.alpha = 0.0
        return back
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backView)
        view.addSubview(notificationView)
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.backView.alpha = 0.6
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if setting.get(for: .wallabagIsConfigured), let attachements = getAttachements() {
            let kit = WallabagKit(host: setting.get(for: .host), clientID: setting.get(for: .clientId), clientSecret: setting.get(for: .clientSecret))
            kit.requestAuth(username: setting.get(for: .username), password: setting.getPassword()!) { [unowned self] auth in
                switch auth {
                case .success:
                    for attachement in attachements {
                        attachement.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, _) -> Void in
                            if let shareURL = url as? NSURL {
                                kit.entry(add: shareURL as URL, queue: nil) { [unowned self] response in
                                    switch response {
                                    case .success:
                                        self.clearView()
                                    default:
                                        self.clearView(withError: true)
                                    }
                                }
                            }
                        }
                    }
                default:
                    self.clearView(withError: true)
                }
            }
        }
    }

    private func getAttachements() -> [NSItemProvider]? {
        var att: [NSItemProvider] = []
        guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
            return nil
        }
        for item in items {
            for attachement in item.attachments ?? [] where attachement.hasItemConformingToTypeIdentifier("public.url") {
                att.append(attachement)
            }
        }
        return att
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
