import SwiftUI

public extension View {
    
    /// Hides a view conditionally,
    /// - Parameter visible: Whether this view should be shown or not
    /// - Returns: The same view, possibly hidden
    func isVisible(_ visible: Bool) -> some View {
        return self.opacity(visible ? 1 : 0).allowsHitTesting(visible)
    }
}
