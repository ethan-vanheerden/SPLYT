import Foundation

/// Represents an HTTP request that can be sent.
public protocol NetworkRequest {
    associatedtype Response: Decodable
    
    /// The encapsulated URL request to make
    var urlRequest: URLRequest { get }
}
