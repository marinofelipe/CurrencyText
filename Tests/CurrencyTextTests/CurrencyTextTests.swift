import XCTest
@testable import CurrencyText

final class CurrencyTextTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CurrencyText().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
