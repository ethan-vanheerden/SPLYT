import SwiftUI

public struct Tile<Content: View>: View {
    @EnvironmentObject private var userTheme: UserTheme
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        HStack {
            Spacer()
            content()
                .padding(.vertical, Layout.size(2))
            Spacer()
        }
        .roundedBackground(cornerRadius: Layout.size(2.75),
                           fill: Color(SplytColor.white).shadow(.drop(radius: Layout.size(0.25))))
    }
}
