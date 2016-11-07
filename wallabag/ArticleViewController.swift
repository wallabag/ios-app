//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController {

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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var readButton: UIBarButtonItem!
    @IBOutlet weak var starButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        updateUi()
        
        titleLabel.text = article.title
        contentText.attributedText = article.content.attributedHTML
    }

    private func updateUi() {
        readButton?.title = article.is_archived ? "Unread" : "Readed"
        starButton?.title = article.is_starred ? "Unstar" : "Star"
    }
}
