import Foundation

/// Utility class to build Apple's `URLRequest` in a more convenient way.
public final class URLRequestBuilder {
    public var request: URLRequest
    
    public init(url: URL) {
        self.request = URLRequest(url: url)
    }
    
    /// Returns the built request.
    /// - Returns: The built request
    public func build() -> URLRequest {
        return request
    }
    
    /// Sets the HTTP method of the request.
    /// - Parameter method: The `HTTPMethod` for the request
    /// - Returns: The same class instance to make method chaining possible
    public func setHTTPMethod(_ method: HTTPMethod) -> Self {
        request.httpMethod = method.rawValue
        return self
    }
    
    /// Sets the content type of the request to JSON.
    /// - Returns: The same class instance to make method chaining possible
    public func setJSONContent() -> Self {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
}
