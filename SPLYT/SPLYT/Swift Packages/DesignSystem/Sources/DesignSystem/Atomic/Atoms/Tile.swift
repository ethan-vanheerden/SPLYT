
import SwiftUI

public struct Tile<Content: View>: View {
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
        .roundedBackground(cornerRadius: Layout.size(1.25),
                           fill: Color.splytColor(.white).shadow(.drop(radius: Layout.size(0.25))))
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile {
            Text("Hello World!")
        }
    }
}
