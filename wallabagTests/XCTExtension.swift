import Foundation
import XCTest

extension XCTestCase {
    func loadJSON(filename: String) -> Data {
        let path = Bundle(for: type(of: self)).url(forResource: filename, withExtension: "json")!
        return try! Data(contentsOf: path)
    }
}
