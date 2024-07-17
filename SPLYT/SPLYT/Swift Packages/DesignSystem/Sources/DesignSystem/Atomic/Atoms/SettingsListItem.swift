import SwiftUI

public struct SettingsListItem: View {
    private let viewState: SettingsListItemViewState
    
    public init(viewState: SettingsListItemViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        if let link = viewState.link {
            Link(destination: link) {
                listItem
            }
        } else {
            listItem
        }
    }
    
    @ViewBuilder
    private var listItem: some View {
        HStack {
            IconImage(imageName: viewState.iconName,
                      backgroundColor: viewState.iconBackgroundColor)
            Text(viewState.title)
                .subhead(style: .semiBold)
                .foregroundColor(Color(SplytColor.black))
            Spacer()
        }
    }
}

// MARK: - View State

public struct SettingsListItemViewState: Equatable, Hashable {
    fileprivate let title: String
    fileprivate let iconName: String
    fileprivate let iconBackgroundColor: SplytColor
    fileprivate let link: URL? // If we want it to navigate to a link somewhere
    
    public init(title: String,
                iconName: String,
                iconBackgroundColor: SplytColor,
                link: URL? = nil) {
        self.title = title
        self.iconName = iconName
        self.iconBackgroundColor = iconBackgroundColor
        self.link = link
    }
}
