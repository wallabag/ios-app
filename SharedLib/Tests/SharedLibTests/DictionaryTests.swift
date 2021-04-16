import XCTest

class DictionaryTests: XCTestCase {
    func testMerge() {
        let dic = ["Key": "Value"]
        //let merged = dic.merge(dict: ["OtherKey": "OtherValue"])

        //XCTAssertEqual(["Key": "Value", "OtherKey": "OtherValue"], merged)
    }

    func testMergeWithSameKeyEraseValue() {
        let dic = ["Key": "Value"]
        //let merged = dic.merge(dict: ["Key": "OtherValue"])

        //XCTAssertEqual(["Key": "OtherValue"], merged)
    }
}
