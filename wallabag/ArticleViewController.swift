//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController {

    var article: Article!

    @IBAction func read(_ sender: Any) {
        WallabagApi.patchArticle(article, withParamaters: ["archive": (!article.is_archived).hashValue]) {
            self.readButton.title = !self.article.is_archived ? "Unread" : "Readed"
        }
    }

    @IBAction func star(_ sender: Any) {
        WallabagApi.patchArticle(article, withParamaters: ["starred": (!article.is_starred).hashValue]) {
            self.starButton.title = !self.article.is_starred ? "Unstar" : "Star"
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        readButton.title = article.is_archived ? "Unread" : "Readed"
        starButton.title = article.is_starred ? "Unstar" : "Star"

        titleLabel.text = article.title
        contentText.attributedText = article.content.attributedHTML
    }
}
