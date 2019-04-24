//
//  RetrieveModeTests.swift
//  wallabagTests
//
//  Created by maxime marinel on 24/04/2019.
//

@testable import wallabag
import XCTest

class RetrieveModeTests: XCTestCase {
    func testAllArticles() {
        XCTAssertEqual("All articles", RetrieveMode.allArticles.humainReadable())
        XCTAssertEqual("TRUEPREDICATE", RetrieveMode.allArticles.predicate().description)
    }

    func testArchivedArticles() {
        XCTAssertEqual("Read articles", RetrieveMode.archivedArticles.humainReadable())
        XCTAssertEqual("isArchived == 1", RetrieveMode.archivedArticles.predicate().description)
    }

    func testUnarchivedArticles() {
        XCTAssertEqual("Unread articles", RetrieveMode.unarchivedArticles.humainReadable())
        XCTAssertEqual("isArchived == 0", RetrieveMode.unarchivedArticles.predicate().description)
    }

    func testStarredArticles() {
        XCTAssertEqual("Starred articles", RetrieveMode.starredArticles.humainReadable())
        XCTAssertEqual("isStarred == 1", RetrieveMode.starredArticles.predicate().description)
    }
}
