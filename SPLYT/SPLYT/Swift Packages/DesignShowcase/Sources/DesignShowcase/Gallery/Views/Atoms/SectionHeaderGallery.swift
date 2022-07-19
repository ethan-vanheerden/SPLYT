import SwiftUI
import DesignSystem

struct SectionHeaderGallery: View {
    var body: some View {
        VStack {
            SectionHeader(viewState: SectionHeaderViewState(text: "TITLE"))
            SectionHeader(viewState: SectionHeaderViewState(text: "LONGER TITLE VERY LONG"))
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.horizontal)
    }
}
