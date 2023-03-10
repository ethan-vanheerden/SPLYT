
import Caching

public final class MockCacheInteractor<R: CacheRequest>: CacheInteractorType {
    public let request: R
    public private(set) var savedData: R.CacheData? = nil
    
    public init(request: R) {
        self.request = request
    }
    
    public var fileExistsThrow = false
    public var stubFileExists = false
    public func fileExists() throws -> Bool {
        if fileExistsThrow { throw MockError.someError }
        return stubFileExists
    }
    
    public var loadThrow = false
    public var stubData: R.CacheData?
    public func load() throws -> R.CacheData {
        guard !loadThrow,
              let stubData = stubData ?? savedData else { throw MockError.someError }
        return stubData
    }
    
    public var saveThrow = false
    public private(set) var saveCalled = false
    public func save(data: R.CacheData) throws {
        saveCalled = true
        if saveThrow { throw MockError.someError }
        savedData = data // Update the saved data
    }
}
