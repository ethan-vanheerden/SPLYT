
public enum TabSelection: CaseIterable {
    case home
    case history
    case settings
    
    var imageName: String {
        switch self {
        case .home:
            return "house.fill"
        case .history:
            return "book.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return Strings.home
        case .history:
            return Strings.history
        case .settings:
            return Strings.settings
        }
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let home = "Home"
    static let history = "History"
    static let settings = "Settings"
}
