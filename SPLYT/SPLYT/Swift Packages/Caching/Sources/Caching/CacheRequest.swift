import Foundation

/// Represents a request to retrieve some cached data on the phone.
public protocol CacheRequest {
    /// The expected deserialized type of the cache request.
    associatedtype CacheData: Codable
    
    /// The filename which the expected data is stored in (relative to the Documents/ directory).
    var filename: String { get }
}
