//
//  ArticleManager.swift
//  wallabag
//
//  Created by maxime marinel on 22/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import Foundation

struct ArticleManager {

    fileprivate var articles: [Article] = []

    mutating func setArticles(articles: [Article]) {
        self.articles = articles
    }

    mutating func addArticles(articles: [Article]) {
        self.articles += articles
    }

    func getArticles() -> [Article] {
        return self.articles
    }

    func getArticle(atIndex: Int) -> Article {
        return self.articles[atIndex]
    }

    mutating func removeArticle(atIndex: Int) {
        self.articles.remove(at: atIndex)
    }

    mutating func update(article: Article, at: Int) {
        self.articles[at] = article
    }

    mutating func insert(article: Article) {
        if !self.articles.contains(where: { $0.id == article.id }) {
            self.articles.insert(article, at: 0)
        }
    }
}
