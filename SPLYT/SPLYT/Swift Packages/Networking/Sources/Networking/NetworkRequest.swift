import Foundation

/// Represents an HTTP request that can be sent.
public protocol NetworkRequest {
    /// The expected deserialized type of the network request.
    associatedtype Response: Decodable
    
    /// Creates a `URLRequest` used for the networking call.
    func createRequest() async throws -> URLRequest
}

public enum NetworkError: Error {
    case invalidURL
    case unsupportedResponse
}

/// Used for requests where we don't require/care about the response
public struct NoResponse: Codable { }
