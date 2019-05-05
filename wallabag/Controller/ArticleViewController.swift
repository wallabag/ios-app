//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import RealmSwift
import TUSafariActivity
import UIKit
import WallabagCommon
import WebKit

protocol ArticleViewControllerProtocol {
    var entry: Entry! { get set }
}

final class ArticleViewController: UIViewController, ArticleViewControllerProtocol {
    var analytics: AnalyticsManagerProtocol!
    var themeManager: ThemeManagerProtocol!
    var podcastController: PodcastViewController?
    var setting: SettingProtocol!

    var entry: Entry! {
        didSet {
            updateUi()
        }
    }

    var deleteHandler: ((_ entry: Entry) -> Void)?
    var readHandler: ((_ entry: Entry) -> Void)?
    var starHandler: ((_ entry: Entry) -> Void)?
    var addHandler: (() -> Void)?

    enum PodcastViewState {
        case show
        case hidden
    }

    var podcastViewState: PodcastViewState = .hidden {
        didSet {
            if podcastViewState == .show {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                               animations: {
                                   self.podcastView.center.y -= self.podcastView.bounds.height
                                   self.podcastView.layoutIfNeeded()
                }, completion: nil)
                podcastView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                               animations: {
                                   self.podcastView.center.y += self.podcastView.bounds.height
                                   self.podcastView.layoutIfNeeded()
                               }, completion: { (_: Bool) -> Void in
                                   self.podcastView.isHidden = true
                })
            }
        }
    }

    @IBOutlet var contentWeb: WKWebView!
    @IBOutlet var readButton: UIBarButtonItem!
    @IBOutlet var starButton: UIBarButtonItem!
    @IBOutlet var speechButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var podcastView: UIView!

    @IBAction func add(_: Any) {
        addHandler?()
    }

    @IBAction func read(_: Any) {
        readHandler?(entry)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func star(_: Any) {
        starHandler?(entry)
        updateUi()
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if let controller = segue.destination as? PodcastViewController {
            controller.entry = entry
            podcastController = controller
            Log("prepare podcast view")
        }
    }

    override func viewDidAppear(_: Bool) {
        podcastViewState = .hidden
    }

    @IBAction func speech(_: Any) {
        // podcastViewState = podcastViewState == .show ? .hidden : .show
        if let podcastController = podcastController {
            podcastController.playPressed(podcastController.playButton)
        }
    }

    @IBAction func shareMenu(_ sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: [URL(string: entry.url!) as Any], applicationActivities: [TUSafariActivity()])
        shareController.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]
        shareController.popoverPresentationController?.barButtonItem = sender

        analytics.send(.shareArticle)
        present(shareController, animated: true)
    }

    @IBAction func deleteArticle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete".localized, message: "Are you sure?".localized, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive, handler: { _ in
            self.deleteHandler?(self.entry)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.popoverPresentationController?.barButtonItem = sender

        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        analytics.sendScreenViewed(.articleView)
        navigationItem.title = entry.title
        updateUi()
        setupAccessibilityLabel()
        contentWeb.load(entry: entry, withTheme: setting.get(for: .theme), justify: setting.get(for: .justifyArticle))
        contentWeb.navigationDelegate = self
        contentWeb.scrollView.delegate = self
        contentWeb.backgroundColor = themeManager.getBackgroundColor()

        UIApplication.shared.isIdleTimerDisabled = true

        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }

    private func updateUi() {
        readButton?.image = entry.isArchived ? #imageLiteral(resourceName: "readed") : #imageLiteral(resourceName: "unreaded")
        starButton?.image = entry.isStarred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")
    }
}

extension ArticleViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(entry.screenPosition)), animated: true)
    }
}

extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        try? Realm().write {
            entry.screenPosition = Float(scrollView.contentOffset.y)
        }
    }
}

extension ArticleViewController {
    private func setupAccessibilityLabel() {
        readButton.accessibilityLabel = "Read".localized
        starButton.accessibilityLabel = "Star".localized
        speechButton.accessibilityLabel = "Speech".localized
        deleteButton.accessibilityLabel = "Delete".localized
    }
}
