import SwiftUI
import DesignSystem

struct IconImageGallery: View {
    
    var body: some View {
        VStack {
            Spacer()
            IconImage(imageName: "theatermask.and.paintbrush.fill",
                      backgroundColor: .darkBlue)
            IconImage(imageName: "stopwatch.fill",
                      backgroundColor: .blue)
            IconImage(imageName: "pencil",
                      imageColor: .red,
                      backgroundColor: .yellow)
            Spacer()
        }
    }
}
