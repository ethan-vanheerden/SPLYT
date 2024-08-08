import SwiftUI

struct IconButtonStyle: ButtonStyle {
    @EnvironmentObject private var userTheme: UserTheme
    private let iconName: String // Apple built-in image names
    private let style: IconButtonConfiguration
    private let iconColor: SplytColor
    private let isEnabled: Bool
    private let animationEnabled: Bool
    private let iconSize = Layout.size(3)
    private let backgroundSize = Layout.size(4)
    private let cornerRadius = Layout.size(1)
    
    init(iconName: String,
         style: IconButtonConfiguration,
         iconColor: SplytColor,
         isEnabled: Bool,
         animationEnabled: Bool) {
        self.iconName = iconName
        self.style = style
        self.iconColor = iconColor
        self.isEnabled = isEnabled
        self.animationEnabled = animationEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        styleView(configuration: configuration)
            .opacity(isEnabled ? 1 : 0.5)
    }
    
    @ViewBuilder
    private func styleView(configuration: Configuration) -> some View {
        switch style {
        case let .primary(backgroundColor, outlineColor):
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    baseImage
                    Spacer()
                }
                Spacer()
            }
            .frame(width: backgroundSize, height: backgroundSize)
            
            .foregroundColor(ButtonUtils.animationColor(configuration: configuration,
                                                        normalColor: Color(iconColor),
                                                        pressedColor: Color(backgroundColor 
                                                                            ?? userTheme.theme),
                                                        animationEnabled: animationEnabled))
            .roundedBackground(cornerRadius: cornerRadius,
                               fill: ButtonUtils.animationColor(configuration: configuration,
                                                                normalColor: Color(backgroundColor
                                                                                   ?? userTheme.theme),
                                                                pressedColor: Color(SplytColor.clear),
                                                                animationEnabled: animationEnabled).gradient)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: Layout.size(0.25))
                    .fill(Color(outlineColor ?? backgroundColor ?? userTheme.theme).gradient)
            )
        case .secondary:
            baseImage
                .frame(width: backgroundSize, height: backgroundSize)
                .foregroundColor(ButtonUtils.animationColor(configuration: configuration,
                                                            normalColor: Color(iconColor),
                                                            pressedColor: Color(iconColor).opacity(0.5),
                                                            animationEnabled: animationEnabled))
        }
    }
    
    @ViewBuilder
    private var baseImage: some View {
        Image(systemName: iconName)
            .imageScale(.large)
    }
}
