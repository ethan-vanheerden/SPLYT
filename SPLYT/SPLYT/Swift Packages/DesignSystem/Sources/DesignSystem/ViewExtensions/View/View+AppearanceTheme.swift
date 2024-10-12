import SwiftUI

public extension View {
    /// Applies the user's chosen appearance theme to this view.
    /// - Returns: The view with the user's appearance preference applied
    func withAppearanceTheme() -> some View {
        return self.modifier(AppearanceThemeModifier())
    }
}

struct AppearanceThemeModifier: ViewModifier {
    @ObservedObject var theme = AppearanceTheme.shared

    func body(content: Content) -> some View {
        content
            .preferredColorScheme(theme.appearanceMode.colorScheme)
    }
}
