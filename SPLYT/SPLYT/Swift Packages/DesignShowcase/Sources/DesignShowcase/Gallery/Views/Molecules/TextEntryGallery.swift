import DesignSystem
import SwiftUI

struct TextEntryGallery: View {
    @State private var textOne = ""
    @State private var textTwo = ""
    @State private var textThree = ""
    private let viewStateOne = TextEntryViewState(placeholder: "Placeholder text")
    private let viewStateTwo = TextEntryViewState(placeholder: "No cancel button",
                                                  includeCancelButton: false)
    private let viewStateThree = TextEntryViewState(placeholder: "Search...",
                                                    iconName: "magnifyingglass")
    
    var body: some View {
        VStack(spacing: Layout.size(4)) {
            Spacer()
            TextEntry(text: $textOne, viewState: viewStateOne)
            Text("Entered text: \(textOne)")
            
            TextEntry(text: $textTwo, viewState: viewStateTwo)
            Text("Entered text: \(textTwo)")
            
            TextEntry(text: $textThree, viewState: viewStateThree)
            Text("Entered text: \(textThree)")
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
