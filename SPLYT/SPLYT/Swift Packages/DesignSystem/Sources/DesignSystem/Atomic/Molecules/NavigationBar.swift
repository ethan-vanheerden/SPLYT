
import SwiftUI

/// Just a view state since this will be used with a view modifier
public struct NavigationBarViewState: Equatable {
    let title: String
    let subtitle: String?
    let size: NavigationBarSize
    let position: NavigationBarPosition
    
    public init(title: String,
                subtitle: String? = nil,
                size: NavigationBarSize = .medium,
                position: NavigationBarPosition = .center) {
        self.title = title
        self.subtitle = subtitle
        self.size = size
        self.position = position
    }
}

// MARK: - Size

public enum NavigationBarSize {
    case small
    case medium
    case large
}

public enum NavigationBarPosition {
    case left
    case center
}
