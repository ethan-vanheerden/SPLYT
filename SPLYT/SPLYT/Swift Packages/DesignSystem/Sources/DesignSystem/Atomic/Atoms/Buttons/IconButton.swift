
import SwiftUI

public struct IconButton: View {
    private let iconName: String // Apple built-in image names
    private let style: IconButtonConfiguration
    private let iconColor: SplytColor
    private let isEnabled: Bool
    private let animationEnabled: Bool
    private let action: () -> Void
    
    public init(iconName: String,
                style: IconButtonConfiguration = .primary(backgroundColor: .white, outlineColor: .lightBlue),
                iconColor: SplytColor = .lightBlue,
                isEnabled: Bool = true,
                animationEnabled: Bool = true,
                action: @escaping () -> Void) {
        self.iconName = iconName
        self.style = style
        self.iconColor = iconColor
        self.isEnabled = isEnabled
        self.animationEnabled = animationEnabled
        self.action = action
    }
    
    public var body: some View {
        Button("") { action() }
            .buttonStyle(IconButtonStyle(iconName: iconName,
                                         style: style,
                                         iconColor: iconColor,
                                         isEnabled: isEnabled,
                                         animationEnabled: animationEnabled))
            .allowsHitTesting(isEnabled)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IconButton(iconName: "plus") { }
            IconButton(iconName: "minus",
                       style: .primary(backgroundColor: .red),
                       iconColor: .white) { }
            IconButton(iconName: "gamecontroller",
                       style: .primary(backgroundColor: .red, outlineColor: .yellow),
                       iconColor: .green) { }
            IconButton(iconName: "circle.square",
                       style: .secondary,
                       iconColor: .green) { }
        }
    }
}

// MARK: - Button Style

public enum IconButtonConfiguration {
    case primary(backgroundColor: SplytColor, outlineColor: SplytColor? = nil)
    case secondary
}
