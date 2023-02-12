
import SwiftUI


import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Displays a custom navigation bar on this view
    /// - Parameters:
    ///   - state: The navigation bar state with rendering instructions
    ///   - backAction: Action for the back button (if not given, there is no back button)
    /// - Returns: This view with the navigation bar applied
    func navigationBar(state: NavigationBarViewState, backAction: (() -> Void)? = nil) -> some View {
        NavigationStack { // Need to wrap in a NavigationStack to show toolbar
            self
                .navigationBarTitleDisplayMode(.inline) // Gets rid of extra space below toolbar
                .toolbar {
                    if let backAction = backAction {
                        ToolbarItem(placement: .navigation) {
                            Button(action: { backAction() }) {
                                Image(systemName: "chevron.backward")
                                    .tint(Color.splytColor(.black))
                            }
                        }
                    }
                        ToolbarItem(placement: getToolbarPlacement(position: state.position)) {
                            Text(state.title)
                                .subtitleText()
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
}
