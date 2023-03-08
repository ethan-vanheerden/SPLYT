
import SwiftUI
import DesignSystem

struct NavigationBarGallery: View {
    @Environment(\.dismiss) private var dismiss
    let state = NavigationBarViewState(title: "Title", subtitle: "This is a subtitle")
    
    var body: some View {
        Text("You can't have more than one navigation bar on the same screen without Xcode having a heart attack 💅")
            .padding(.horizontal)
            .multilineTextAlignment(.center)
            .navigationBar(viewState: state, backAction: { dismiss() }) {
                SplytButton(text: "save", action: { })
            }
    }
}
