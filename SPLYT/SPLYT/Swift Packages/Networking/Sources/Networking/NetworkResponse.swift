import Foundation

/// A type to wrap the response that an API request returns.
public struct NetworkResponse {
    public let responseObject: Decodable
    public let statusCode: URLResponse
}
