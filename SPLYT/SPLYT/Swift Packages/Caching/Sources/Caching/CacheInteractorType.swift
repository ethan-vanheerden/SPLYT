import Foundation

/// Protocol which defines behaviors needed to perfrom cache requests.
public protocol CacheInteractorType {
    
    /// Loads data using the given cache request.
    /// - Parameter with: The cache request to perfrom
    /// - Returns: The request's Codable object, or throws error
    static func load<R: CacheRequest>(with: R) throws -> R.CacheData
    
    static func save<R: CacheRequest>(with: R, data: R.CacheData) throws
}

// MARK: - Implementation

@available(iOS 16.0, *)
public struct CacheInterator: CacheInteractorType {
    public static func load<R: CacheRequest>(with request: R) throws -> R.CacheData where R : CacheRequest {
        let url = try CacheURLCreator.getURL(for: request)
        let file = try FileHandle(forReadingFrom: url)
        let object = try JSONDecoder().decode(R.CacheData.self, from: file.availableData)
        return object
    }
    
    public static func save<R>(with request: R, data: R.CacheData) throws where R : CacheRequest {
        let url = try CacheURLCreator.getURL(for: request)
        let data = try JSONEncoder().encode(data)
        try data.write(to: url)
    }
}
