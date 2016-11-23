//
//  ArticleManagerTests.swift
//  wallabag
//
//  Created by maxime marinel on 22/11/2016.
//  Copyright © 2016 maxime marinel. All rights reserved.
//

import XCTest
@testable import wallabag

class ArticleManagerTests: XCTestCase {

    let article = Article(fromDictionary: [
        "id": 42,
        "created_at": "",
        "updated_at": "",
        "is_archived": false,
        "is_starred": false,
        "tags": [],
        "user_email": "user@mail.com",
        "user_id": 1,
        "user_name": "wallabag",
    ]
    )

    let article1 = Article(fromDictionary: [
        "id": 43,
        "created_at": "",
        "updated_at": "",
        "is_archived": false,
        "is_starred": false,
        "tags": [],
        "user_email": "user@mail.com",
        "user_id": 1,
        "user_name": "wallabag",
    ]
    )

    func testSetArticles() {
        var manager = ArticleManager()
        XCTAssertEqual(0, manager.getArticles().count)
        manager.setArticles(articles: [article])
        XCTAssertEqual(1, manager.getArticles().count)
    }

    func testAddArticles() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article])
        manager.addArticles(articles: [article])
        XCTAssertEqual(2, manager.getArticles().count)
    }

    func testGetArticleAtIndex() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article, article1])
        XCTAssertEqual(43, manager.getArticle(atIndex: 1).id)
    }

    func testRemoveArticleAtIndex() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article, article1])
        XCTAssertEqual(2, manager.getArticles().count)
        manager.removeArticle(atIndex: 0)
        XCTAssertEqual(1, manager.getArticles().count)
        XCTAssertEqual(43, manager.getArticle(atIndex: 0).id)
    }

    func testUpdateArticleAtIndex() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article])
        XCTAssertEqual(1, manager.getArticles().count)
        XCTAssertEqual(42, manager.getArticle(atIndex: 0).id)
        manager.update(article: article1, at: 0)
        XCTAssertEqual(1, manager.getArticles().count)
        XCTAssertEqual(43, manager.getArticle(atIndex: 0).id)
    }

    func testInsertArticleAtIndex() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article])
        XCTAssertEqual(1, manager.getArticles().count)
        XCTAssertEqual(42, manager.getArticle(atIndex: 0).id)
        manager.insert(article: article1)
        XCTAssertEqual(2, manager.getArticles().count)
        XCTAssertEqual(43, manager.getArticle(atIndex: 0).id)
    }

    func testInsertArticleAtIndexDontInsertArticleAlreadyInList() {
        var manager = ArticleManager()
        manager.setArticles(articles: [article])
        XCTAssertEqual(1, manager.getArticles().count)
        XCTAssertEqual(42, manager.getArticle(atIndex: 0).id)
        manager.insert(article: article)
        XCTAssertEqual(1, manager.getArticles().count)
    }
}
