import XCTest

import SharedLibTests

var tests = [XCTestCaseEntry]()
tests += SharedLibTests.allTests()
XCTMain(tests)
