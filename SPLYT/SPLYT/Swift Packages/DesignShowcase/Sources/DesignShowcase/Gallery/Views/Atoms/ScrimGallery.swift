import SwiftUI
import DesignSystem

struct ScrimGallery: View {
    var body: some View {
        ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color(SplytColor.red))
                Text("MORE TEXT")
                    .largeTitle()
                Rectangle()
                    .fill(Color(SplytColor.lightBlue))
            }
            Scrim()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
