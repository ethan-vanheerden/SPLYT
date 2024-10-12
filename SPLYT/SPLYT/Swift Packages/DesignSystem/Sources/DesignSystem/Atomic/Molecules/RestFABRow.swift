import SwiftUI
import Core

public struct RestFABRow: View {
    @State private var isPressed = false
    @EnvironmentObject private var userTheme: UserTheme
    private let seconds: Int
    private let tapAction: () -> Void
    
    public init(seconds: Int,
                tapAction: @escaping () -> Void) {
        self.seconds = seconds
        self.tapAction = tapAction
    }
    
    public var body: some View {
        Text(TimeUtils.minSec(seconds: seconds))
            .subhead()
            .padding(Layout.size(1))
            .frame(width: Layout.size(10))
            .roundedBackground(cornerRadius: Layout.size(1), 
                               fill: Color(SplytColor.background).shadow(.drop(color: Color(SplytColor.shadow),
                                                                               radius: Layout.size(0.25))))
            .scaleEffect(isPressed ? 0.9 : 1)
            .gesture(press)
    }
    
    private var press: some Gesture {
        DragGesture(minimumDistance: .zero)
            .onChanged { _ in
                withAnimation {
                    isPressed = true
                }
            }
            .onEnded { _ in
                tapAction()
                withAnimation {
                    isPressed = false
                }
            }
    }
}
