import Foundation

/// Defines behaviors for constructing URLs for making network requests.
public struct ServerURL {
    // TODO: This will have to be HTTPS before sensitive info can be sent/received
    private static let baseServerPath = "http://splyt-dev.us-east-1.elasticbeanstalk.com"
    
    /// Creates a URL by combining the given subpath with the `baseServerPath`.
    /// - Parameter path: The subpath to be appended to the base server path, e.g. "/my/path"
    /// - Returns: The URL to make the request
    public static func createURL(path: String) -> URL {
        if let url = URL(string: baseServerPath + path) {
            return url
        } else {
            fatalError("Unable to construct URL with path \(path).")
        }
    }
}
