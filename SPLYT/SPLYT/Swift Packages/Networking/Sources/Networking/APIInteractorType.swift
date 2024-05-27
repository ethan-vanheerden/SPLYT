import Foundation

/// Protocol which defines behaviors needed to perform API requests.
public protocol APIInteractorType {
    
    /// Performs an API request.
    /// - Parameter with: The request to perform
    /// - Returns: The response object for the request, or throws
    static func performRequest<R: NetworkRequest>(with: R) async throws -> R.Response
}



// MARK: - Implementation

public struct APIInteractor: APIInteractorType {
    public init() {}
    
    public static func performRequest<R: NetworkRequest>(with request: R) async throws -> R.Response {
        /// Can do better error handling here if needed
        let responseJson = try await URLSession.shared.data(for: request.createRequest())
        // Convert response data to a string for printing
        if let jsonString = String(data: responseJson.0, encoding: .utf8) {
            print("Response JSON: \(jsonString)")
        } else {
            print("Failed to convert response data to string")
        }
        return try JSONDecoder().decode(R.Response.self, from: responseJson.0)
    }
}
