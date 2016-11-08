//
//  ArticleLoader.swift
//  wallabag
//
//  Created by maxime marinel on 07/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import UIKit

class ArticleLoader: NSObject {

    static func load(_ article: Article) -> String {
        let html = try! String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)

        return String(format: html, arguments: [article.title, article.content])
    }
}
