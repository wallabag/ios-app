//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import TUSafariActivity
import WallabagKit

final class ArticleViewController: UIViewController {

    var lastOffsetY: CGFloat = 0
    var update: Bool = true
    var entry: Entry! {
        didSet {
            updateUi()
        }
    }

    var deleteHandler: ((_ entry: Entry) -> Void)?
    var readHandler: ((_ entry: Entry) -> Void)?
    var starHandler: ((_ entry: Entry) -> Void)?
    var addHandler: (() -> Void)?

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

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

    @IBAction func shareMenu(_ sender: UIBarButtonItem) {
        let activity = TUSafariActivity()
        let shareController = UIActivityViewController(activityItems: [URL(string: entry.url!) as Any], applicationActivities: [activity])
        shareController.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]

        shareController.popoverPresentationController?.barButtonItem = sender

        present(shareController, animated: true)
    }

    @IBAction func deleteArticle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteHandler?(self.entry)
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.popoverPresentationController?.barButtonItem = sender

        present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = entry.title
        updateUi()
        loadArticleContent()
        contentWeb.delegate = self
        contentWeb.scrollView.delegate = self
        contentWeb.backgroundColor = Setting.getTheme().backgroundColor
    }

    private func loadArticleContent() {
        DispatchQueue.main.async { [unowned self] in
            self.contentWeb.loadHTMLString(self.contentForWebView(self.entry), baseURL: Bundle.main.bundleURL)
        }
    }

    func contentForWebView(_ entry: Entry) -> String {
        do {
            let html = try String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)

            let justify = Setting.isJustifyArticle() ? "justify.css" : ""
            let theme = Setting.getTheme()

            return String(format: html, arguments: [justify, theme.rawValue, entry.title!, entry.content!])
        } catch {
            fatalError("Unable to load article view")
        }
    }

    private func updateUi() {
        readButton?.image = entry.is_archived ? #imageLiteral(resourceName: "readed") : #imageLiteral(resourceName: "unreaded")
        starButton?.image = entry.is_starred ? #imageLiteral(resourceName: "starred") : #imageLiteral(resourceName: "unstarred")
    }
}

extension ArticleViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.scrollView.setContentOffset(CGPoint(x: 0.0, y: Double(self.entry.screen_position)), animated: true)
    }
}

extension ArticleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastOffsetY = scrollView.contentOffset.y
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let hide = scrollView.contentOffset.y > self.lastOffsetY
        self.navigationController?.setNavigationBarHidden(hide, animated: true)
        entry.screen_position = Float(scrollView.contentOffset.y)

        CoreData.saveContext()
    }
}
