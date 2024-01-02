import XCTest
@testable import Networking
import Mocking

final class URLRequestBuilderTests: XCTestCase {
    private var mockUserAuth: MockUserAuth!
    
    override func setUp() async throws {
        self.mockUserAuth = MockUserAuth()
    }
    
    func testBuilder() async throws {
        let testURL = try XCTUnwrap(URL(string: "www.test.com"))
        let testBody = ["field": "value"]
        
        let result = await URLRequestBuilder(url: testURL, userAuth: mockUserAuth)
            .setHTTPMethod(.get)
            .setJSONContent()
            .setBearerAuth()
            .setBody(testBody)
            .build()
        
        let expectedHTTPHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mockUserAuth.stubAuthToken)"
        ]
        
        let expectedBody = try JSONEncoder().encode(testBody)
        
        XCTAssertEqual(result.url, testURL)
        XCTAssertEqual(result.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(result.allHTTPHeaderFields, expectedHTTPHeaders)
        XCTAssertEqual(result.httpBody, expectedBody)
    }
}
