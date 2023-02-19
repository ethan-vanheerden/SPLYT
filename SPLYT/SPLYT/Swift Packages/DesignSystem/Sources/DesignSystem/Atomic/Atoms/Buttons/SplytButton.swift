import SwiftUI

public struct SplytButton: View {
    private let text: String
    private let color: SplytColor
    private let textColor: SplytColor
    private let action: () -> Void
    
    public init(text: String,
                color: SplytColor = .lightBlue,
                textColor: SplytColor = .white,
                action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.textColor = textColor
        self.action = action
    }
    
    public var body: some View {
        Button("") { action() }
            .buttonStyle(SplytButtonStyle(text: text,
                                          color: color,
                                          textColor: textColor))
    }
}

// NOTE: Custom fonts are not rendered in previews
struct SplytButton_Previews: PreviewProvider {
    static var previews: some View {
        SplytButton(text: "NEXT", action: { })
    }
}
