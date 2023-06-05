import SwiftUI

struct ProgressBarStyle: ProgressViewStyle {
    private let color: SplytColor
    private let outlineColor: SplytColor?
    
    init(color: SplytColor,
         outlineColor: SplytColor?) {
        self.color = color
        self.outlineColor = outlineColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return GeometryReader { proxy in
            HStack {
                RoundedRectangle(cornerRadius: Layout.size(1))
                    .fill(Color(splytColor: color))
                    .shadow(color: Color(splytColor: color), radius: Layout.size(0.5))
                    .frame(width: proxy.size.width * fractionCompleted)
                Spacer()
            }
        }
        .frame(height: Layout.size(2))
        .strokeBorder(cornerRadius: Layout.size(1), color: outlineColor ?? .clear)
    }
}
