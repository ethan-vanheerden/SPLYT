
import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Conditionally displays a dialog in front of this view.
    /// - Parameters:
    ///   - isOpen: Condition to display the dialog or not
    ///   - title: Dialog title
    ///   - subtitle: Dialog subtitle
    ///   - type: The button type of the dialog
    ///   - content: Addiontal view content to display in the dialog
    /// - Returns: This view with the dialog conditionally displayed
    func dialog<Content: View>(isOpen: Bool,
                               title: String,
                               subtitle: String? = nil,
                               type: DialogType,
                               content: @escaping () -> Content = { EmptyView() }) -> some View {
        ZStack {
            self
            ZStack {
                Scrim()
                    .edgesIgnoringSafeArea(.all)
                Dialog(title: title,
                       subtitle: subtitle,
                       type: type,
                       content: content)
                .scaleEffect(isOpen ? 1 : 0.1)
            }
            .isVisible(isOpen)
            .animation(.default, value: isOpen)
        }
    }
}
