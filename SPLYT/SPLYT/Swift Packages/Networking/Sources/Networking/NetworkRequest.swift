import Foundation

/// Represents an HTTP request that can be sent.
public protocol NetworkRequest {
    /// The expected deserialized type of the network request.
    associatedtype Response: Decodable
    
    /// Creates a `URLRequest` used for the networking call.
    func createRequest() async -> URLRequest
}
