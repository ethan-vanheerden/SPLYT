import SwiftUI

struct ProgressBarStyle: ProgressViewStyle {
    @EnvironmentObject private var userTheme: UserTheme
    @Namespace private var animation
    private let color: SplytColor?
    
    init(color: SplytColor?) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return GeometryReader { proxy in
            HStack {
                RoundedRectangle(cornerRadius: Layout.size(1))
                    .fill(Color(color ?? userTheme.theme).gradient)
                    .frame(width: proxy.size.width * fractionCompleted)
                    .matchedGeometryEffect(id: "PROGRESS_BAR", in: animation)
                Spacer()
            }.animation(.snappy, value: fractionCompleted)
        }
        .frame(height: Layout.size(2))
        .gradientStrokeBorder(cornerRadius: Layout.size(1), color: color ?? userTheme.theme)
    }
}
