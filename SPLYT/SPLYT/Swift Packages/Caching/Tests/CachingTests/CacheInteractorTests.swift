import XCTest
@testable import Caching

final class CacheInteractorTests: XCTestCase {
    private var sut: CacheInteractor<MockCacheRequest>!
    private let request = MockCacheRequest()
    private let mockData = "Hello World!"
    
    override func setUp() async throws {
        // Get rid of any mock loaded data if it exists
        let url = try CacheURLCreator.getURL(for: request)
        if FileManager.default.fileExists(atPath: url.relativePath) {
            try FileManager.default.removeItem(at: url)
        }
        self.sut = CacheInteractor(request: request)
    }
    
    func testLoadAndSave() throws {
        // Try to load data which is not there
        XCTAssertThrowsError(try sut.load())
        
        // Now save some data
        try saveMockData()
        
        // Try loading the data again
        let loadedData = try sut.load()
        XCTAssertEqual(loadedData, mockData)
    }
    
    func testFileExists() throws {
        // Make sure file does not exists yet
        XCTAssertFalse(try sut.fileExists())
        
        // Now save some data
        try saveMockData()
        
        // Now file should exist
        XCTAssertTrue(try sut.fileExists())
    }
    
    private func saveMockData() throws {
        try sut.save(data: mockData)
    }
}
