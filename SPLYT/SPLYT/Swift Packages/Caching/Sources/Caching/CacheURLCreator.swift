import Foundation

/// Helper struct to create the URLs that a CacheRequest is associated with.
@available(iOS 16.0, *)
// TODO: Look at ScenePhases for when we should be saving data in the background
struct CacheURLCreator {
    
    /// Gets the URL associated with the given CacheRequest
    /// - Parameter request: the CacheRequest to get the path of
    /// - Returns: the URL (path) or throws error
    static func getURL<R: CacheRequest>(for request: R) throws -> URL {
        // The Documents/ directory is what stores user data for our specific app
        return try FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false)
        .appending(path: request.filename)
    }
}
