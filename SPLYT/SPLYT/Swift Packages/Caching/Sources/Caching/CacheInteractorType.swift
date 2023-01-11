import Foundation

/// Protocol which defines behaviors needed to perfrom cache requests.
public protocol CacheInteractorType {
    associatedtype Request: CacheRequest
    
    var request: Request { get }
    
    /// Determines if the file associated with the cache request exists.
    /// - Returns: `true` if the file exists, `false` otherwise
    func fileExists() throws -> Bool
    
    /// Loads data using the cache request.
    /// - Returns: The request's Codable object, or throws error
    func load() throws -> Request.CacheData
    
    /// Saves the given data using the cache request.
    /// - Parameters:
    ///   - data: The data to save
    func save(data: Request.CacheData) throws
}

// MARK: - Implementation

@available(iOS 16.0, *)
public struct CacheInteractor<R: CacheRequest>: CacheInteractorType {
    public let request: R
    
    public init(request: R) {
        self.request = request
    }
    
    public func fileExists() throws -> Bool {
        let url = try CacheURLCreator.getURL(for: request)
        return FileManager.default.fileExists(atPath: url.relativePath)
    }
    
    public func load() throws -> R.CacheData {
        let url = try CacheURLCreator.getURL(for: request)
        let file = try FileHandle(forReadingFrom: url)
        let object = try JSONDecoder().decode(R.CacheData.self, from: file.availableData)
        return object
    }
    
    public func save(data: R.CacheData) throws {
        let url = try CacheURLCreator.getURL(for: request)
        let data = try JSONEncoder().encode(data)
        try data.write(to: url)
    }
}
