import Foundation
import UserAuth

/// Utility class to build Apple's `URLRequest` in a more convenient way.
public final class URLRequestBuilder {
    private var request: URLRequest
    private let userAuth: UserAuthType
    
    public init(url: URL, userAuth: UserAuthType) {
        self.request = URLRequest(url: url)
        self.userAuth = userAuth
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
    
    public func setBearerAuth() async -> Self {
        let token = await userAuth.getAuthToken()
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return self
    }
    
    public func setBody(_ body: Encodable) -> Self {
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            return self
        } catch {
            return self
        }
    }
}
