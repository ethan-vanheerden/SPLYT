import SwiftUI
import DesignSystem

struct TextGallery: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(SplytFont.allCases, id: \.self) { style in
                    SectionHeader(viewState: SectionHeaderViewState(text: style.rawValue))
                    Text("Large Title")
                        .largeTitle(style: style)
                    Text("Title 1")
                        .title1(style: style)
                    Text("Body")
                        .body(style: style)
                    Text("Footnote")
                        .footnote(style: style)
                }
            }
            .padding(.horizontal)
        }
    }
}
