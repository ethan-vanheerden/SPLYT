import SwiftUI
import DesignSystem

struct ScrimGallery: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color.splytColor(.red))
                Text("MORE TEXT")
                    .megaText()
                Rectangle()
                    .fill(Color.splytColor(.lightBlue))
            }
            Scrim()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
