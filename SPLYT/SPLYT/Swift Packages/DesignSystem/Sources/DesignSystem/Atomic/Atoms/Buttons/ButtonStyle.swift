import SwiftUI

struct SplytButtonStyle: ButtonStyle {
    private let text: String
    private let color: SplytColor
    private let textColor: SplytColor
    private let cornerRadius = Layout.size(1)
    
    init(text: String,
         color: SplytColor = .lightBlue,
         textColor: SplytColor = .white) {
        self.text = text
        self.color = color
        self.textColor = textColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            Text(text)
                .body()
                .padding(.vertical, Layout.size(1))
            Spacer()
        }
        .foregroundColor(configuration.isPressed ? Color.splytColor(color) : Color.splytColor(textColor))
        .roundedBackground(cornerRadius: cornerRadius, fill: configuration.isPressed ? Color.splytColor(textColor) : Color.splytColor(color))
        .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: Layout.size(0.25))
                    .fill(Color.splytColor(color))
            )
        .padding(Layout.size(2))
    }
}
