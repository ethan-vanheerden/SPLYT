import SwiftUI
import DesignSystem

struct TagGallery: View {
    var body: some View {
        VStack(spacing: Layout.size(1)) {
            Spacer()
            Tag(viewState: TagViewState(title: "Drop Set", color: .green))
            Tag(viewState: TagViewState(title: "Rest/Pause", color: .gray))
            Tag(viewState: TagViewState(title: "Eccentric", color: .red))
            Spacer()
        }
        .padding(.horizontal)
    }
}
