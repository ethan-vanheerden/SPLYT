import XCTest
@testable import Networking

final class URLRequestBuilderTests: XCTestCase {
    func testBuilder() throws {
        let testURL = try XCTUnwrap(URL(string: "www.test.com"))
        let expectedHTTPHeaders: [String: String] = [
            "Content-Type": "application/json"
        ]
        let result = URLRequestBuilder(url: testURL)
            .setHTTPMethod(.get)
            .setJSONContent()
            .build()
        
        XCTAssertEqual(result.url, testURL)
        XCTAssertEqual(result.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(result.allHTTPHeaderFields, expectedHTTPHeaders)
    }
}
