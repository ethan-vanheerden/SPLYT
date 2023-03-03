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
                    Text("Title 2")
                        .title2(style: style)
                    Text("Title 3")
                        .title3(style: style)
                    Text("Title 4")
                        .title4(style: style)
                    Text("Body")
                        .body(style: style)
                    Text("Subheading")
                        .subhead(style: style)
                    Text("Footnote")
                        .footnote(style: style)
                }
            }
            .padding(.horizontal)
        }
    }
}
