
import SwiftUI
import DesignSystem

struct TileGallery: View {
    
    var body: some View {
        VStack {
            Tile {
                Text("Hello World!")
            }
            
            Tile {
                Circle()
                    .fill(Color.red)
                    .frame(width: Layout.size(1))
            }
        }.padding()
    }
}
