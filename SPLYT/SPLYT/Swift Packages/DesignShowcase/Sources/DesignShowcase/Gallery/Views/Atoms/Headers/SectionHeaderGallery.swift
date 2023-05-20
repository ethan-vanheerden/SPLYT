import SwiftUI
import DesignSystem

struct SectionHeaderGallery: View {
    var body: some View {
        VStack {
            SectionHeader(viewState: SectionHeaderViewState(title: "TITLE"))
            SectionHeader(viewState: SectionHeaderViewState(title: "LONGER TITLE VERY LONG"))
                .foregroundColor(.blue)
            SectionHeader(viewState: SectionHeaderViewState(title: "No Line",
                                                            includeLine: false))
            Spacer()
        }
        .padding(.horizontal)
    }
}
