import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Displays a custom navigation bar on this view
    /// - Parameters:
    ///   - state: The navigation bar state with rendering instructions
    ///   - backAction: Action for the back button (if not given, there is no back button)
    ///   - content: An additional view to display to the right of the navigation bar if needed
    /// - Returns: This view with the navigation bar applied
    func navigationBar<Content: View>(viewState: NavigationBarViewState,
                                      backAction: (() -> Void)? = nil,
                                      content: @escaping () -> Content = { EmptyView() }) -> some View {
        NavigationStack { // Need to wrap in a NavigationStack to show toolbar
            self
                .navigationBarTitleDisplayMode(.inline) // Gets rid of extra space below toolbar
                .toolbar {
                    if let backAction = backAction {
                        ToolbarItem(placement: .navigation) {
                            IconButton(iconName: "chevron.backward",
                                       style: .secondary,
                                       iconColor: .black) { backAction() }
                        }
                    }
                    ToolbarItem(placement: getToolbarPlacement(position: viewState.position)) {
                        VStack {
                            title(viewState.title, size: viewState.size)
                            if let subtitle = viewState.subtitle {
                                Text(subtitle)
                                    .footnote(style: .medium)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        content()
                    }
                }
        }
    }
    
    private func getToolbarPlacement(position: NavigationBarPosition) -> ToolbarItemPlacement {
        switch position {
        case .left:
            return .navigation
        case .center:
            return .principal
        }
    }
    
    @ViewBuilder
    private func title(_ title: String, size: NavigationBarSize) -> some View {
        switch size {
        case .small:
            Text(title)
                .body()
        case .medium:
            Text(title)
                .title4()
        case .large:
            Text(title)
                .title1()
        }
    }
}
