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
        .foregroundColor(ButtonUtils.animationColor(configuration: configuration,
                                                    normalColor: Color(splytColor: textColor),
                                                    pressedColor: Color(splytColor: color),
                                                    animationEnabled: animationEnabled))
        .roundedBackground(cornerRadius: cornerRadius, fill: ButtonUtils.animationColor(configuration: configuration,
                                                                                        normalColor: Color(splytColor: color),
                                                                                        pressedColor: Color(splytColor: textColor),
                                                                                        animationEnabled: animationEnabled))
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
}
