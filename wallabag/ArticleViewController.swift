//
//  ArticleViewController.swift
//  wallabag
//
//  Created by maxime marinel on 23/10/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    var article: Article!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title

        titleLabel.text = article.title

        contentText.attributedText = article.content.attributedHTML
    }
}
