import SwiftUI

public struct SplytButton: View {
    private let text: String
    private let size: ButtonSize
    private let color: SplytColor
    private let textColor: SplytColor
    private let isEnabled: Bool
    private let action: () -> Void
    
    public init(text: String,
                size: ButtonSize = .primary,
                color: SplytColor = .lightBlue,
                textColor: SplytColor = .white,
                isEnabled: Bool = true,
                action: @escaping () -> Void) {
        self.text = text
        self.size = size
        self.color = color
        self.textColor = textColor
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button("") { action() }
            .buttonStyle(SplytButtonStyle(text: text,
                                          size: size,
                                          color: color,
                                          textColor: textColor,
                                          isEnabled: isEnabled))
            .allowsHitTesting(isEnabled)
    }
}

// MARK: - Button Size

public enum ButtonSize {
    case primary
    case secondary
}

// NOTE: Custom fonts are not rendered in previews
struct SplytButton_Previews: PreviewProvider {
    static var previews: some View {
        SplytButton(text: "NEXT", action: { })
    }
}
