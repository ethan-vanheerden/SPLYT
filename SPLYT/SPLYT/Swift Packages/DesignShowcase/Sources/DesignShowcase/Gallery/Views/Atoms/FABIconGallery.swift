import SwiftUI
import DesignSystem

struct FABIconGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(6)) {
            FABIcon(type: FABIconType(size: .primary, imageName: "plus"))
            FABIcon(type: FABIconType(size: .secondary, imageName: "calendar"))
        }
    }
}
