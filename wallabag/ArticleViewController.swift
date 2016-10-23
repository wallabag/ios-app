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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = article.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
