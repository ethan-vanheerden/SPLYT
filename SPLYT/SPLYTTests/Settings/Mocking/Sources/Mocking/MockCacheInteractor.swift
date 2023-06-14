import Caching

public final class MockCacheInteractor: CacheInteractorType {
    
    public init() { }
    
    public var fileExistsThrow = false
    public var stubFileExists = false
    public func fileExists(request: any CacheRequest) throws -> Bool {
        if fileExistsThrow { throw MockError.someError }
        return stubFileExists
    }
    
    public var loadThrow = false
    public var stubData: Codable? = nil
    public func load<T: CacheRequest>(request: T) throws -> T.CacheData {
        guard !loadThrow,
              let stubData = stubData as? T.CacheData else { throw MockError.someError }
        return stubData
    }
    
    public var saveThrow = false
    public private(set) var saveCalled = false
    public func save<T: CacheRequest>(request: T, data: T.CacheData) throws {
        saveCalled = true
        if saveThrow { throw MockError.someError }
        stubData = data // Update the saved data
    }
    
    public var deleteThrow = false
    public private(set) var deleteCalled = false
    public func deleteFile(request: any CacheRequest) throws {
        deleteCalled = true
        if deleteThrow { throw MockError.someError }
    }
    
    /// Use this function in the setUp of your tests
    public func reset() {
        fileExistsThrow = false
        stubFileExists = false
        loadThrow = false
        stubData = nil
        saveThrow = false
        saveCalled = false
        deleteThrow = false
        deleteCalled = false
    }
}
