import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(WallabagKitTests.allTests),
        ]
    }
#endif
