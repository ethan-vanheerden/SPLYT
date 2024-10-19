import Foundation

/// Protocol which defines behaviors needed to perform API requests.
public protocol APIInteractorType {
    
    /// Performs an API request.
    /// - Parameter with: The request to perform
    /// - Returns: The response object for the request, or throws
    static func performRequest<R: NetworkRequest>(with: R) async throws -> NetworkResponse<R>
}



// MARK: - Implementation

public struct APIInteractor: APIInteractorType {
    public init() {}
    
    public static func performRequest<R: NetworkRequest>(with request: R) async throws -> NetworkResponse<R> {
        /// Can do better error handling here if needed
        let fetchedResponse = try await URLSession.shared.data(for: request.createRequest())
        
        let responseData = fetchedResponse.0
        let response = fetchedResponse.1
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unsupportedResponse
        }
        
        let decodedResponseBody = try JSONDecoder().decode(R.Response.self, from: responseData)
        
        let networkResponse = NetworkResponse(requestType: R.self,
                                              statusCode: httpResponse.statusCode,
                                              responseBody: decodedResponseBody)
        
        return networkResponse
    }
}
