import Foundation

/// Represents an HTTP request that can be sent.
public protocol NetworkRequest {
    associatedtype Response: Decodable
    
    /// Creates a `URLRequest` used for the networking call.
    func createRequest() -> URLRequest
}
