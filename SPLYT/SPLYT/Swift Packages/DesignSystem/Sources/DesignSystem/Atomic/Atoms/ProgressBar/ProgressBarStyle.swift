import SwiftUI

struct ProgressBarStyle: ProgressViewStyle {
    @EnvironmentObject private var userTheme: UserTheme
    private let color: SplytColor?
    
    init(color: SplytColor?) {
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return GeometryReader { proxy in
            HStack {
                RoundedRectangle(cornerRadius: Layout.size(1))
                    .fill(Color(splytColor: color ?? userTheme.theme))
                    .frame(width: proxy.size.width * fractionCompleted)
                Spacer()
            }
        }
        .frame(height: Layout.size(2))
        .strokeBorder(cornerRadius: Layout.size(1), color: color ?? userTheme.theme)
    }
}
