import SwiftUI

public struct HomeFABRow: View {
    @EnvironmentObject private var userTheme: UserTheme
    private let viewState: HomeFABRowViewState
    private let tapAction: () -> Void
    
    public init(viewState: HomeFABRowViewState,
                tapAction: @escaping () -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
    }
    
    public var body: some View {
        HStack {
            Text(viewState.title)
                .footnote()
            FABIcon(viewState: fabIconType,
                    tapAction: tapAction)
        }
    }
    
    private var fabIconType: FABIconViewState {
        return FABIconViewState(size: .secondary(backgroundColor: userTheme.theme,
                                                 iconColor: .white),
                                imageName: viewState.imageName)
    }
} // TODO: Custom exercise button on build workout, appearnce view

// MARK: - ViewState

public struct HomeFABRowViewState: Equatable {
    let title: String
    let imageName: String
    
    public init(title: String,
                imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
