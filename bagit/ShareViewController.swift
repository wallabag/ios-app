import Combine
import Foundation
import MobileCoreServices
import SharedLib
import Social
import UIKit
import UniformTypeIdentifiers
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
        image.image = UIImage(named: "logo")

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
            backView.alpha = 0.6
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
                guard let shareURL else {
                    self.clearView(withError: .retrievingURL)
                    return
                }

                Task {
                    do {
                        _ = try await kit.requestTokenAsync()
                        let _: WallabagEntry = try await kit.send(to: WallabagEntryEndpoint.add(url: shareURL))
                        self.clearView(withError: nil)
                    } catch {
                        self.clearView(withError: .duringAdding)
                    }
                }
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

        let propertyList = UTType.propertyList.identifier
        let publicURL = UTType.url.identifier

        item.attachments?.forEach { attachment in
            if attachment.hasItemConformingToTypeIdentifier(propertyList) {
                attachment.loadItem(
                    forTypeIdentifier: propertyList,
                    options: nil,
                    completionHandler: { item, _ in
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
