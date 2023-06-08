import XCTest
@testable import Caching

final class CacheInteractorTests: XCTestCase {
    private let sut = CacheInteractor.self
    private let request = MockCacheRequest()
    private let mockData = "Hello World!"
    
    override func setUp() async throws {
        // Get rid of any mock loaded data if it exists
        let url = try CacheURLCreator.getURL(for: request)
        if FileManager.default.fileExists(atPath: url.relativePath) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    func testLoadAndSave() throws {
        // Try to load data which is not there
        XCTAssertThrowsError(try sut.load(request: request))
        
        // Now save some data
        try saveMockData()
        
        // Try loading the data again
        let loadedData = try sut.load(request: request)
        XCTAssertEqual(loadedData, mockData)
    }
    
    func testFileExists() throws {
        // Make sure file does not exists yet
        XCTAssertFalse(try sut.fileExists(request: request))
        
        // Now save some data
        try saveMockData()
        
        // Now file should exist
        XCTAssertTrue(try sut.fileExists(request: request))
    }
    
    private func saveMockData() throws {
        try sut.save(request: request, data: mockData)
    }
}
