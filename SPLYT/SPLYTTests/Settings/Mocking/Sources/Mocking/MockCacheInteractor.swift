import Caching

public final class MockCacheInteractor: CacheInteractorType {
    public private(set) static var savedData: Codable? = nil
    
    public static var fileExistsThrow = false
    public static var stubFileExists = false
    public static func fileExists(request: any CacheRequest) throws -> Bool {
        if fileExistsThrow { throw MockError.someError }
        return stubFileExists
    }
    
    public static var loadThrow = false
    public static var stubData: Codable? = nil
    public static func load<T: CacheRequest>(request: T) throws -> T.CacheData {
        guard !loadThrow,
              let stubData = stubData as? T.CacheData else { throw MockError.someError }
        return stubData
    }
    
    public static var saveThrow = false
    public private(set) static var saveCalled = false
    public static func save<T: CacheRequest>(request: T, data: T.CacheData) throws {
        saveCalled = true
        if saveThrow { throw MockError.someError }
        savedData = data // Update the saved data
    }
    
    public static var deleteThrow = false
    public private(set) static var deleteCalled = false
    public static func deleteFile(request: any CacheRequest) throws {
        deleteCalled = true
        if deleteThrow { throw MockError.someError }
    }
}
