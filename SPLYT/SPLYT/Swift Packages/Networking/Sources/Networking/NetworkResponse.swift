import Foundation

/// A type to wrap the response that an API request returns.
public struct NetworkResponse<N: NetworkRequest> {
    public let responseObject: N.Response
    public let statusCode: URLResponse
}
