//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit
import TUSafariActivity

final class ArticleViewController: UIViewController {

    var delegate: ArticlesTableViewController?
    var index: IndexPath!
    var update: Bool = true
    var article: Article! {
        didSet {
            updateUi()
        }
    }

    @IBAction func read(_ sender: Any) {
        WallabagApi.patchArticle(article, withParamaters: ["archive": (!article.is_archived).hashValue]) { article in
            self.article = article
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func star(_ sender: Any) {
        WallabagApi.patchArticle(article, withParamaters: ["starred": (!article.is_starred).hashValue]) { article in
            self.article = article
        }
    }

    @IBAction func shareMenu(_ sender: UIBarButtonItem) {
        let activity = TUSafariActivity()
        let shareController = UIActivityViewController(activityItems: [URL(string: article.url)], applicationActivities: [activity])
        shareController.excludedActivityTypes = [.airDrop, .addToReadingList, .copyToPasteboard]

        shareController.popoverPresentationController?.barButtonItem = sender

        present(shareController, animated: true)
    }

    @IBAction func deleteArticle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            WallabagApi.deleteArticle(self.article) {
                self.update = false
                self.delegate?.delete(self.article, indexPath: self.index)
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.popoverPresentationController?.barButtonItem = sender

        present(alert, animated: true)
    }

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        updateUi()

        contentWeb.loadHTMLString(article.contentForWebView(), baseURL: Bundle.main.bundleURL)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil && update {
            delegate?.update(article, atIndex: index)
        }
    }

    private func updateUi() {
        readButton?.title = article.is_archived ? "Unread" : "Read"
        starButton?.title = article.is_starred ? "Unstar" : "Star"
    }
}
