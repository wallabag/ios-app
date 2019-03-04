//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import TUSafariActivity
import RealmSwift
import WallabagCommon

protocol ArticleViewControllerProtocol {
    var entry: Entry! { get set }
}

final class ArticleViewController: UIViewController, ArticleViewControllerProtocol {
    var analytics: AnalyticsManager!
    var themeManager: ThemeManager!
    var podcastController: PodcastViewController?

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
                self.podcastView.isHidden = false
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                               animations: {
                                self.podcastView.center.y += self.podcastView.bounds.height
                                self.podcastView.layoutIfNeeded()
                }, completion: {(_ completed: Bool) -> Void in
                    self.podcastView.isHidden = true
                })
            }
        }
    }

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!
    @IBOutlet weak var speechButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var podcastView: UIView!

    @IBAction func add(_ sender: Any) {
        addHandler?()
    }

    @IBAction func read(_ sender: Any) {
        readHandler?(entry)
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func star(_ sender: Any) {
        starHandler?(entry)
        updateUi()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PodcastViewController {
            controller.entry = entry
            podcastController = controller
            Log("prepare podcast view")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        podcastViewState = .hidden
    }

    @IBAction func speech(_ sender: Any) {
        //podcastViewState = podcastViewState == .show ? .hidden : .show
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
        contentWeb.load(entry: entry)
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

extension ArticleViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(self.entry.screenPosition)), animated: true)
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
