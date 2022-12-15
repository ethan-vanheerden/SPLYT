import XCTest
@testable import Caching

final class CacheInteractorTests: XCTestCase {
    let request = MockCacheRequest()
    
    override func setUp() async throws {
        // Get rid of any mock loaded data if it exists
        let url = try CacheURLCreator.getURL(for: request)
        if FileManager.default.fileExists(atPath: url.relativePath) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    func testLoadAndSave() throws {
        // Try to load data which is not there
        XCTAssertThrowsError(try CacheInterator.load(with: request))
        
        // Now save some data
        let mockData = "Hello World!"
        try CacheInterator.save(with: request, data: mockData)
        
        // Try loading the data again
        let loadedData = try CacheInterator.load(with: request)
        XCTAssertEqual(loadedData, mockData)
    }
}
