import SwiftUI
import DesignSystem

struct ScrimGallery: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color(splytColor: .red))
                Text("MORE TEXT")
                    .largeTitle()
                Rectangle()
                    .fill(Color(splytColor: .lightBlue))
            }
            Scrim()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
