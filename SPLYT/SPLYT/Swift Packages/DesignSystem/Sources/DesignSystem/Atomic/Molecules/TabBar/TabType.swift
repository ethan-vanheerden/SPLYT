
public enum TabType: CaseIterable {
    case home
    case history
    case settings
    
    func imageName(isSelected: Bool) -> String {
        switch self {
        case .home:
            return isSelected ? "house.fill" : "house"
        case .history:
            return isSelected ? "book.fill" : "book"
        case .settings:
            return isSelected ? "gearshape.fill" : "gearshape"
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
