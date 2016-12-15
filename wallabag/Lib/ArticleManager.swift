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

    static func contentForWebView(_ article: Article) -> String {
        let html = try! String(contentsOfFile: Bundle.main.path(forResource: "article", ofType: "html")!)

        let justify = Setting.isJustifyArticle() ? "justify.css" : ""
        let theme = Setting.getTheme()

        return String(format: html, arguments: [justify, theme.rawValue, article.title, article.content])
    }
}
