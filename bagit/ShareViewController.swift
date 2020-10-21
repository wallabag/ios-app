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
        print(WallabagUserDefaults.registred)
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
            // Missing clearView

        } else {
            clearView(withError: .unregistredApp)
        }
    }

    private func getUrl(completion: @escaping (String?) -> Void) {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else {
            completion(nil)
            return
        }

        let propertyList = String(kUTTypePropertyList)
        let publicURL = String(kUTTypeURL)

        for attachment in item.attachments! {
            print(attachment.hasItemConformingToTypeIdentifier(String(kUTTypeURL)))
        }

        item.attachments?.forEach { attachment in
            if attachment.hasItemConformingToTypeIdentifier(propertyList) {
                attachment.loadItem(
                    forTypeIdentifier: propertyList,
                    options: nil,
                    completionHandler: { (item, _) -> Void in
                        guard let dictionary = item as? NSDictionary,
                              let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                              let href = results["href"] as? String
                        else {
                            completion(nil)
                            return
                        }

                        completion(href)
                    }
                )
            }

            if attachment.hasItemConformingToTypeIdentifier(publicURL) {
                attachment.loadItem(forTypeIdentifier: publicURL, options: nil) { item, _ in
                    completion((item as? NSURL)!.absoluteString!)
                }
            }
        }
    }

    private func clearView(withError: ShareExtensionError?) {
        UIView.animate(withDuration: 0.5, animations: {
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
