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
    var index: Int!
    var article: Article! {
        didSet {
            updateUi()
        }
    }

    override func didMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            delegate?.update(article, atIndex: index)
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

    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var contentWeb: UIWebView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        updateUi()

        contentWeb.loadHTMLString(ArticleLoader.load(article), baseURL: Bundle.main.bundleURL)

        /*contentText.attributedText = article.content.attributedHTML
         contentWeb.loadHTMLString(article.content, baseURL: nil)
         contentWeb.scalesPageToFit = true
         contentWeb.contentMode = .scaleAspectFit*/
    }

    private func updateUi() {
        readButton?.title = article.is_archived ? "Unread" : "Readed"
        starButton?.title = article.is_starred ? "Unstar" : "Star"
    }
}
