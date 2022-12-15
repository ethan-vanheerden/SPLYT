import XCTest
@testable import Caching

final class CacheURLCreatorTests: XCTestCase {
    private let request = MockCacheRequest()
    
    func testGetURL() throws {
        let url = try CacheURLCreator.getURL(for: request)
        XCTAssertEqual(url.lastPathComponent, "mock_data_test")
    }
}
