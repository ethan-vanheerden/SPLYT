import SwiftUI

struct ButtonUtils {
    
    /// Gets the color when a button is pressed.
    /// - Parameters:
    ///   - configuration: The configuration of the button (determines if it is being pressed)
    ///   - normalColor: The normal color in the button
    ///   - pressedColor: The transformed color when the button is pressed and animations are enabled
    ///   - animationEnabled: Whether the button supports animation or not
    /// - Returns: The new color in the button
    static func animationColor(configuration: ButtonStyle.Configuration,
                               normalColor: Color,
                               pressedColor: Color,
                               animationEnabled: Bool) -> Color {
        if animationEnabled {
            return configuration.isPressed ? pressedColor : normalColor
        } else {
            return normalColor
        }
    }
}
