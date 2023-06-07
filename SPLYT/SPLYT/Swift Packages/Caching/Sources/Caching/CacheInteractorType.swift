import Foundation

/// Protocol which defines behaviors needed to perfrom cache requests.
public protocol CacheInteractorType {
    /// Determines if the file associated with the cache request exists.
    /// - Returns: `true` if the file exists, `false` otherwise
    static func fileExists(request: any CacheRequest) throws -> Bool
    
    /// Loads data using the cache request.
    /// - Returns: The request's Codable object, or throws error
    static func load<T: CacheRequest>(request: T) throws -> T.CacheData
    
    /// Saves the given data using the cache request.
    /// - Parameters:
    ///   - data: The data to save
    static func save<T: CacheRequest>(request: T, data: T.CacheData) throws
    
    /// Deletes the cached file associated with the cache request.
    static func deleteFile(request: any CacheRequest) throws
}

// MARK: - Implementation

public struct CacheInteractor: CacheInteractorType {
    
    public static func fileExists(request: any CacheRequest) throws -> Bool {
        let url = try CacheURLCreator.getURL(for: request)
        return FileManager.default.fileExists(atPath: url.relativePath)
    }
    
    public static func load<T: CacheRequest>(request: T) throws -> T.CacheData {
        let url = try CacheURLCreator.getURL(for: request)
        let file = try FileHandle(forReadingFrom: url)
        let object = try JSONDecoder().decode(T.CacheData.self, from: file.availableData)
        return object
    }
    
    public static func save<T: CacheRequest>(request: T, data: T.CacheData) throws {
        let url = try CacheURLCreator.getURL(for: request)
        let data = try JSONEncoder().encode(data)
        try data.write(to: url)
    }
    
    public static func deleteFile(request: any CacheRequest) throws {
        let url = try CacheURLCreator.getURL(for: request)
        try FileManager.default.removeItem(at: url)
    }
}
