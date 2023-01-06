
import SwiftUI
import DesignSystem

struct NavigationBarGallery: View {
    let viewStateOne = NavigationBarViewState(title: "Title")
    let viewStateTwo = NavigationBarViewState(title: "Another Title")
    
    var body: some View {
        VStack(alignment: .leading, spacing: Layout.size(5)) {
            NavigationBar(viewState: viewStateOne)
            NavigationBar(viewState: viewStateTwo, dismissAction: { print("Hello, world!")})
        }
    }
}
