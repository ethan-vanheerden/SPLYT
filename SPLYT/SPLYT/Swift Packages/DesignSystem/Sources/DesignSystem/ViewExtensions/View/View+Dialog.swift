
import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Conditionally displays a dialog in front of this view.
    /// - Parameters:
    ///   - isOpen: Wether to show the dialog or not
    ///   - viewState: The rendering instructions for the dialog
    ///   - primaryAction: The primary button action in the dialog
    ///   - secondaryAction: The secondary button action in the dialog
    ///   - content: Additional view to be in the dialog
    /// - Returns: This view with the dialog conditionally displayed in front of it
    func dialog<Content: View>(isOpen: Bool,
                               viewState: DialogViewState,
                               primaryAction: @escaping () -> Void,
                               secondaryAction: (() -> Void)? = nil,
                               content: @escaping () -> Content = { EmptyView() }) -> some View {
        ZStack {
            self
            ZStack {
                Scrim()
                    .edgesIgnoringSafeArea(.all)
                Dialog(viewState: viewState,
                       primaryAction: primaryAction,
                       secondaryAction: secondaryAction,
                       content: content)
                .scaleEffect(isOpen ? 1 : 0.1)
            }
            .isVisible(isOpen)
            .animation(.default, value: isOpen)
        }
    }
}
