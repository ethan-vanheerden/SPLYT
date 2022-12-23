
import SwiftUI
import DesignSystem

struct ScrimGallery: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color.red)
            }
            Scrim()
        }
        
    }
}
