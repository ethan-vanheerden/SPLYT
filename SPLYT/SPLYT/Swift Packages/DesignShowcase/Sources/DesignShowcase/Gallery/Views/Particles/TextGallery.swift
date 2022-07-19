import SwiftUI
import DesignSystem

struct TextGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(1)) {
            Text("MEGA Text")
                .megaText()
            Text("TITLE Text")
                .titleText()
            Text("SUBTITLE Text")
                .subtitleText()
            Text("DESCRIPTION Text")
                .descriptionText()
            Text("BODY Text")
                .bodyText()
        }
    }
}
