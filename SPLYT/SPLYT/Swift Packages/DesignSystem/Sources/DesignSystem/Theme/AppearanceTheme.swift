import SwiftUI

public final class AppearanceTheme: ObservableObject {
    @AppStorage(ThemeStorage.appearanceMode.rawValue) private var appearanceMode: AppearanceMode = .automatic
    
    private init() { }
    
    public static let shared: AppearanceTheme = {
        let instance = AppearanceTheme()
        return instance
    }()
    
    public var colorScheme: ColorScheme? {
        return appearanceMode.colorScheme
    }
    
    public var mode: AppearanceMode {
        return appearanceMode
    }
}

// MARK: - Mode

public enum AppearanceMode: String, CaseIterable {
    case automatic
    case light
    case dark
    
    public var title: String {
        switch self {
        case .automatic:
            return Strings.automatic
        case .light:
            return Strings.light
        case .dark:
            return Strings.dark
        }
    }
    
    public var imageName: String {
        switch self {
        case .automatic:
            return "sparkles"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .automatic:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    // UIKit-usable
    public var uiUserInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .automatic:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let light = "Light"
    static let dark = "Dark"
    static let automatic = "Automatic"
}
