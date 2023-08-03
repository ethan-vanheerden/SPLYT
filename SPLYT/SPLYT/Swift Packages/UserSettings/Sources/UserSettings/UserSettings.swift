import Foundation

// MARK: - Protocol

/// Protocol used to read and write simple user preferences. This is used to make the
/// UserDefauls behavior injectable and help with testing.
public protocol UserSettings {
    /// Gets the object associated with the given string key.
    /// - Parameter forKey: The key for the stored object
    /// - Returns: The object if it exists
    func object(forKey: String) -> Any?
    
    /// Sets the given object for the associated key.
    /// - Parameters:
    ///   - object: The object to set for the key
    ///   - forKey: The key to set the object to
    func set(_ object: Any?, forKey: String)
}

extension UserDefaults: UserSettings { }

/// Extension to allow for calling the functions with the `UserSettingsKey` enum
public extension UserSettings {
    func object(forKey key: UserSettingsKey) -> Any? {
        return object(forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: UserSettingsKey) {
        set(object, forKey: key.rawValue)
    }
}
