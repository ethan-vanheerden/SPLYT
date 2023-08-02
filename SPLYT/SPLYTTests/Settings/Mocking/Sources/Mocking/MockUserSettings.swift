import UserSettings

public final class MockUserSettings: UserSettings {
    // Put mock objects for keys here
    private var mockDefaults: [UserSettingsKey: Any] = [
        .restPresets: [60, 90, 120]
    ]
    
    public func object(forKey key: String) -> Any? {
        let settingsKey = UserSettingsKey(rawValue: key)
        
        guard let settingsKey = settingsKey else { return nil }
        
        return mockDefaults[settingsKey]
    }
    
    public func set(_ object: Any?, forKey key: String) {
        let settingsKey = UserSettingsKey(rawValue: key)
        
        guard let settingsKey = settingsKey else { return }
        
        mockDefaults[settingsKey] = object
    }
}
