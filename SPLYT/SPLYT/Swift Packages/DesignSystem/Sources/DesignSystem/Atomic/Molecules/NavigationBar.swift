
import SwiftUI

/// Just a view state since this will be used with a view modifier
public struct NavigationBarViewState: Equatable, ItemViewState {
    public let id: AnyHashable
    let title: String
    let position: NavigationBarPosition
    
    public init(id: AnyHashable = UUID(),
                title: String,
                position: NavigationBarPosition = .center) {
        self.id = id
        self.title = title
        self.position = position
    }
}

public enum NavigationBarPosition {
    case left
    case center
}
