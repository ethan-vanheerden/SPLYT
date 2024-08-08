import SwiftUI

struct SplytButtonStyle: ButtonStyle {
    @EnvironmentObject private var userTheme: UserTheme
    private let text: String
    private let type: SplytButtonType
    private let textColor: SplytColor
    private let isEnabled: Bool
    private let animationEnabled: Bool
    private let cornerRadius = Layout.size(2)
    
    init(text: String,
         type: SplytButtonType,
         textColor: SplytColor,
         isEnabled: Bool,
         animationEnabled: Bool) {
        self.text = text
        self.type = type
        self.textColor = textColor
        self.isEnabled = isEnabled
        self.animationEnabled = animationEnabled
    }
    
    
    func makeBody(configuration: Configuration) -> some View {
        body(configuration: configuration)
            .opacity(isEnabled ? 1 : 0.5)
    }
    
    @ViewBuilder
    private func body(configuration: Configuration) -> some View {
        switch type {
        case .primary(let color),
                .secondary(let color),
                .loading(let color):
            baseButton
                .foregroundColor(ButtonUtils.animationColor(configuration: configuration,
                                                            normalColor: Color(textCologit gittttttr),
                                                            pressedColor: Color(color ?? userTheme.theme),
                                                            animationEnabled: animationEnabled))
                .roundedBackground(cornerRadius: cornerRadius,
                                   fill: ButtonUtils.animationColor(configuration: configuration,
                                                                    normalColor: Color(color ?? userTheme.theme),
                                                                    pressedColor: Color(SplytColor.clear),
                                                                    animationEnabled: animationEnabled))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(lineWidth: Layout.size(0.25))
                        .fill(Color(color ?? userTheme.theme))
                )
        case .textOnly(let fillsSpace):
            Group {
                if fillsSpace {
                    baseButton
                } else {
                    buttonContent
                }
            }
            .lineLimit(1)
            .foregroundColor(ButtonUtils.animationColor(configuration: configuration,
                                                        normalColor: Color(textColor),
                                                        pressedColor: Color(textColor).opacity(0.5),
                                                        animationEnabled: animationEnabled))
        }
    }
    
    @ViewBuilder
    private var baseButton: some View {
        HStack {
            Spacer()
            buttonContent
                .lineLimit(1)
            Spacer()
        }
        .frame(height: Layout.size(4)) // Constant height regardless of button font size
    }
    
    @ViewBuilder
    private var buttonContent: some View {
        switch type {
        case .primary, .textOnly:
            Text(text)
                .subhead()
        case .secondary:
            Text(text)
                .footnote()
        case .loading:
            ProgressView()
                .tint(Color(SplytColor.white))
        }
    }
}
