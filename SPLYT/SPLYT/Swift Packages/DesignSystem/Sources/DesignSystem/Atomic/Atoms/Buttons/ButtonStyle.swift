import SwiftUI

struct SplytButtonStyle: ButtonStyle {
    private let text: String
    private let size: ButtonSize
    private let color: SplytColor
    private let textColor: SplytColor
    private let isEnabled: Bool
    private let cornerRadius = Layout.size(1)
    
    init(text: String,
         size: ButtonSize,
         color: SplytColor,
         textColor: SplytColor,
         isEnabled: Bool) {
        self.text = text
        self.size = size
        self.color = color
        self.textColor = textColor
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            textView
                .lineLimit(1)
            Spacer()
        }
        .frame(height: Layout.size(4)) // Constant height regardless of button font size
        .foregroundColor(configuration.isPressed ? Color.splytColor(color) : Color.splytColor(textColor))
        .roundedBackground(cornerRadius: cornerRadius, fill: configuration.isPressed ? Color.splytColor(textColor) : Color.splytColor(color))
        .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: Layout.size(0.25))
                    .fill(Color.splytColor(color))
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
}
