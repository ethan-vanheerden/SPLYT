import SwiftUI
import DesignSystem

struct SectionHeaderGallery: View {
    var body: some View {
        VStack {
            SectionHeader(viewState: SectionHeaderViewState(title: "TITLE"))
            SectionHeader(viewState: SectionHeaderViewState(title: "LONGER TITLE VERY LONG"))
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.horizontal)
    }
}
