//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

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
        }
    }

    @IBAction func star(_ sender: Any) {
        WallabagApi.patchArticle(article, withParamaters: ["starred": (!article.is_starred).hashValue]) { article in
            self.article = article
        }
    }

    @IBAction func deleteArticle(_ sender: Any?) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            WallabagApi.deleteArticle(self.article) {
                self.update = false
                self.delegate?.delete(self.article, indexPath: self.index)
                self.navigationController?.popToRootViewController(animated: true)
            }
        })
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        updateUi()

        contentWeb.loadHTMLString(ArticleLoader.load(article), baseURL: Bundle.main.bundleURL)
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil && update {
            delegate?.update(article, atIndex: index)
        }
    }

    private func updateUi() {
        readButton?.title = article.is_archived ? "Unread" : "Readed"
        starButton?.title = article.is_starred ? "Unstar" : "Star"
    }
}
