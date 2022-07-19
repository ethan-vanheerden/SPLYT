import SwiftUI
import DesignSystem

struct MenuItemGallery: View {
    private let viewState = MenuItemViewState(title: "TITLE")
    private let subtitleViewState = MenuItemViewState(title: "TITLE",
                                                      subtitle: "THIS IS A SUBTITLE")
    
    var body: some View {
        VStack {
            MenuItem(viewState: viewState) { viewState in
                print(viewState)
            }
            MenuItem(viewState: subtitleViewState) { viewState in
                print(viewState)
            }
            Spacer()
        }
    }
}
