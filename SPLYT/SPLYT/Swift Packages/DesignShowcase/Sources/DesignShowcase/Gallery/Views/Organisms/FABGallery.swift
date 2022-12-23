
import SwiftUI
import DesignSystem

struct FABGallery: View {
    var body: some View {
        FAB(items: [
            FABRowViewState(title: "CREATE NEW PLAN",
                            imageName: "calendar",
                            tapAction: { }),
            FABRowViewState(title: "CREATE NEW WORKOUT",
                            imageName: "figure.strengthtraining.traditional",
                            tapAction: { })
        ])
    }
}

