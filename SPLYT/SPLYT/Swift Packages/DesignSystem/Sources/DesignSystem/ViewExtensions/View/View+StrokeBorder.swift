import SwiftUI

public extension View {
    
    /// Draws a stroke border around this view.
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the border
    ///   - color: The color of the border
    ///   - shadowRadius: The radius of the shadow of the border. If nil, there is no shadow
    /// - Returns: This view with the border around it
    func strokeBorder(cornerRadius: CGFloat,
                      color: SplytColor,
                      shadowRadius: CGFloat? = nil) -> some View {
        let color = Color( color)
        return self
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color)
                .shadow(color: color, radius: shadowRadius ?? 0))
    }
}
