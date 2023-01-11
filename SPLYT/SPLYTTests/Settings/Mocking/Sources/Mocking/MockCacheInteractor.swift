import Caching

public final class MockCacheInteractor<R: CacheRequest>: CacheInteractorType {
    public let request: R
    public var shouldThrow = false
    
    public init(request: R) {
        self.request = request
    }
    
    public var stubFileExists = false
    public func fileExists() throws -> Bool {
        if shouldThrow { throw MockCacheError.someError }
        return stubFileExists
    }
    
    public var stubData: R.CacheData?
    public func load() throws -> R.CacheData {
        guard !shouldThrow,
              let stubData = stubData else { throw MockCacheError.someError }
        return stubData
    }
    
    public var saveCalled = false
    public func save(data: R.CacheData) throws {
        saveCalled = true
        if shouldThrow { throw MockCacheError.someError }
    }
}

public enum MockCacheError: Error {
    case someError
}
