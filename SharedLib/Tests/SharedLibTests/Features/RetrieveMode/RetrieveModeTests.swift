import XCTest
@testable import SharedLib

class RetrieveModeTests: XCTestCase {
    func testAllArticles() {
        XCTAssertEqual("All", RetrieveMode.allArticles.rawValue)
         XCTAssertEqual("TRUEPREDICATE", RetrieveMode.allArticles.predicate().description)
     }

     func testArchivedArticles() {
         XCTAssertEqual("Read", RetrieveMode.archivedArticles.rawValue)
         XCTAssertEqual("isArchived == 1", RetrieveMode.archivedArticles.predicate().description)
     }

     func testUnarchivedArticles() {
         XCTAssertEqual("Unread", RetrieveMode.unarchivedArticles.rawValue)
         XCTAssertEqual("isArchived == 0", RetrieveMode.unarchivedArticles.predicate().description)
     }

     func testStarredArticles() {
         XCTAssertEqual("Starred", RetrieveMode.starredArticles.rawValue)
         XCTAssertEqual("isStarred == 1", RetrieveMode.starredArticles.predicate().description)
     }
}
