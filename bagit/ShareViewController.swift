//
import Combine
//  ShareViewController.swift
//  bagit
//
//  Created by maxime marinel on 30/12/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//
import MobileCoreServices
import Social
import UIKit
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
        back.alpha = 0.0
        return back
    }()

    private var requestCancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backView)
        view.addSubview(notificationView)
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.backView.alpha = 0.6
        }
    }

    override func viewWillAppear(_: Bool) {
        if WallabagUserDefaults.registred {
            let kit = WallabagKit(host: WallabagUserDefaults.host)
            kit.clientId = WallabagUserDefaults.clientId
            kit.clientSecret = WallabagUserDefaults.clientSecret
            kit.username = WallabagUserDefaults.login
            kit.password = WallabagUserDefaults.password

            getUrl { shareURL in
                guard let shareURL = shareURL else {
                    self.clearView(withError: .retrievingURL)
                    return
                }

                self.requestCancellable = kit.send(to: WallabagEntryEndpoint.add(url: shareURL))
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            self.clearView(withError: nil)
                        case .failure:
                            self.clearView(withError: .duringAdding)
                        }
                    }, receiveValue: { (_: WallabagEntry) in

                })
            }
        } else {
            clearView(withError: .unregistredApp)
        }
    }

    private func getUrl(completion: @escaping (String?) -> Void) {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else {
            completion(nil)
            return
        }

        item.attachments?.forEach { attachment in
            if attachment.isURL {
                attachment.getUrl { completion($0) }
            }
            if attachment.isText {
                attachment.getText { text in
                    if text.hasPrefix("http") {
                        completion(text)
                    }
                }
            }
        }
    }

    private func clearView(withError: ShareExtensionError?) {
        UIView.animate(withDuration: 1.0, animations: {
            self.notificationView.alpha = 0.0
        }, completion: { _ in
            if withError != nil {
                let alertController = UIAlertController(title: "Error", message: withError?.localizedDescription, preferredStyle: .alert)
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
