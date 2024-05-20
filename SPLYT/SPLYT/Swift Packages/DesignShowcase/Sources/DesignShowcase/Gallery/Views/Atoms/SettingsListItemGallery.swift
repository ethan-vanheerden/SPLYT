import SwiftUI
import DesignSystem

struct SettingsListItemGallery: View {
    private let viewStateOne = SettingsListItemViewState(title: "Title",
                                                         iconName: "pencil.tip",
                                                         iconBackgroundColor: .darkBlue)
    private let viewStateTwo = SettingsListItemViewState(title: "Linked Title",
                                                         iconName: "link",
                                                         iconBackgroundColor: .green,
                                                         link: URL(string: "https://www.google.com"))
    
    var body: some View {
        VStack(spacing: Layout.size(1)) {
            SettingsListItem(viewState: viewStateOne)
            SettingsListItem(viewState: viewStateTwo)
            Spacer()
        }
        .padding(Layout.size(2))
    }
}
