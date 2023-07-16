import SwiftUI

public struct SplytButton: View {
    private let text: String
    private let type: SplytButtonType
    private let textColor: SplytColor
    private let isEnabled: Bool
    private let animationEnabled: Bool
    private let action: () -> Void
    
    public init(text: String,
                type: SplytButtonType = .primary(),
                textColor: SplytColor = .white,
                isEnabled: Bool = true,
                animationEnabled: Bool = true,
                action: @escaping () -> Void) {
        self.text = text
        self.type = type
        self.textColor = textColor
        self.isEnabled = isEnabled
        self.animationEnabled = animationEnabled
        self.action = action
    }
    
    public var body: some View {
        Button("") { action() }
            .buttonStyle(SplytButtonStyle(text: text,
                                          type: type,
                                          textColor: textColor,
                                          isEnabled: isEnabled,
                                          animationEnabled: animationEnabled))
            .allowsHitTesting(isEnabled)
    }
}

// MARK: - Button Type

public enum SplytButtonType {
    case primary(color: SplytColor = .lightBlue)
    case secondary(color: SplytColor = .lightBlue)
    case textOnly
}

// NOTE: Custom fonts are not rendered in previews
struct SplytButton_Previews: PreviewProvider {
    static var previews: some View {
        SplytButton(text: "NEXT", action: { })
    }
}
