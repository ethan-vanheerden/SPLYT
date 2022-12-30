
import SwiftUI

public struct Tile<Content: View>: View {
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                content()
                    .padding(.vertical)
                    .frame(width: proxy.size.width)
                    .roundedBackground(cornerRadius: Layout.size(1.25), fill: Color.white)
                    .shadow(radius: 0)
                Spacer()
            }
            .shadow(radius: Layout.size(0.25))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Tile {
            Text("Hello World!")
        }
    }
}
