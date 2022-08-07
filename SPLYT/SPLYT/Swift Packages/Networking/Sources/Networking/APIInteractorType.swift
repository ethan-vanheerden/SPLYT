import Foundation

/// Protocol which defines behaviors needed to perform API requests.
public protocol APIInteractorType {
    
    /// Performs an API request.
    /// - Parameter with: The request to perform
    /// - Returns: A `NetworkReponse` for the request, or throws
    static func performRequest<R: NetworkRequest>(with: R) async throws -> NetworkResponse<R>
}



// MARK: - Implementation

public struct APIInteractor: APIInteractorType {
    public static func performRequest<R: NetworkRequest>(with request: R) async throws -> NetworkResponse<R> {
        /// Can do better error handling here if needed
        let response = try await URLSession.shared.data(for: request.createRequest())
        let object = try JSONDecoder().decode(R.Response.self, from: response.0)
        return NetworkResponse(responseObject: object, statusCode: response.1)
    }
}
