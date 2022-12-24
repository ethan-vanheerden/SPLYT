import SwiftUI

public extension View {
    
    /// Applies a rounded background to a view.
    /// - Parameters:
    ///   - cornerRadius: The radius to round the corners
    ///   - fill: The shape style (e.g. Color) to apply to the background
    /// - Returns: The view with the rounded backgroud
    func roundedBackground<S: ShapeStyle>(cornerRadius: CGFloat, fill: S) -> some View {
        return self.background(RoundedRectangle(cornerRadius: cornerRadius).fill(fill))
    }
}
