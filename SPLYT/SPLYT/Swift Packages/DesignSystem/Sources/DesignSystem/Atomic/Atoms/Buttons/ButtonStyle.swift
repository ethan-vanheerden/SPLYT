import SwiftUI

struct SplytButtonStyle: ButtonStyle {
    private let text: String
    private let size: ButtonSize
    private let color: SplytColor
    private let textColor: SplytColor
    private let outlineColor: SplytColor
    private let isEnabled: Bool
    private let animationEnabled: Bool
    private let cornerRadius = Layout.size(1)
    
    init(text: String,
         size: ButtonSize,
         color: SplytColor,
         textColor: SplytColor,
         outlineColor: SplytColor,
         isEnabled: Bool,
         animationEnabled: Bool) {
        self.text = text
        self.size = size
        self.color = color
        self.textColor = textColor
        self.outlineColor = outlineColor
        self.isEnabled = isEnabled
        self.animationEnabled = animationEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            textView
                .lineLimit(1)
            Spacer()
        }
        .frame(height: Layout.size(4)) // Constant height regardless of button font size
        .foregroundColor(animationColor(configuration: configuration,
                                        normalColor: textColor,
                                        pressedColor: color))
        .roundedBackground(cornerRadius: cornerRadius, fill: animationColor(configuration: configuration,
                                                                            normalColor: color,
                                                                            pressedColor: textColor))
        .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: Layout.size(0.25))
                    .fill(Color(splytColor: outlineColor))
            )
        .opacity(isEnabled ? 1 : 0.5)
    }
    
    @ViewBuilder
    private var textView: some View {
        switch size {
        case .primary:
            Text(text)
                .subhead()
        case .secondary:
            Text(text)
                .footnote()
        }
    }
    
    
    /// Gets the color when a button is pressed.
    /// - Parameters:
    ///   - configuration: The configuration of the button (determines if it is being pressed)
    ///   - normalColor: The normal color in the button
    ///   - pressedColor: The transformed color when the button is pressed and animations are enabled
    /// - Returns: The new color in the button
    private func animationColor(configuration: Configuration,
                                normalColor: SplytColor,
                                pressedColor: SplytColor) -> Color {
        if animationEnabled {
            return configuration.isPressed ? Color(splytColor: pressedColor) : Color(splytColor: normalColor)
        } else {
            return Color(splytColor: normalColor)
        }
    }
}
