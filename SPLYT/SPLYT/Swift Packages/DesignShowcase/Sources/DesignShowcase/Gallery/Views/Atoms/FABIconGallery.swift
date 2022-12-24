import SwiftUI
import DesignSystem

struct FABIconGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(6)) {
            FABIcon(type: FABIconType(size: .primary, imageName: "plus"),
                    tapAction: { print("Primary tapped") })
            FABIcon(type: FABIconType(size: .secondary, imageName: "calendar"),
                    tapAction: { print("Secondary tapped") })
        }
    }
}
