import SwiftUI

public extension View {
    /// Applies the user's theme to this view as an environment object.
    /// - Returns: The view with the user's theme appiled
    func withUserTheme() -> some View {
        return self.environmentObject(UserTheme.shared)
    }
}
