import SwiftUI
import DesignSystem

struct FABIconGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(6)) {
            FABIcon(viewState: FABIconViewState(size: .primary(backgroundColor: .lightBlue,
                                                               iconColor: .white),
                                                imageName: "plus"),
                    tapAction: { print("Primary tapped") })
            FABIcon(viewState: FABIconViewState(size: .secondary(backgroundColor: .white,
                                                                 iconColor: .lightBlue),
                                                imageName: "calendar"),
                    tapAction: { print("Secondary tapped") })
        }
    }
}
