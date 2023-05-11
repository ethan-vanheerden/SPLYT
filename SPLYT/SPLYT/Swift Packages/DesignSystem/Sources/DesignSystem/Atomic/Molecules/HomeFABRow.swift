
import SwiftUI

public struct HomeFABRow: View {
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
        return FABIconViewState(size: .secondary(backgroundColor: .white,
                                                 iconColor: .lightBlue),
                                imageName: viewState.imageName)
    }
}

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

struct FABRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeFABRow(viewState: HomeFABRowViewState(title: "CREATE NEW WORKOUT", imageName: "plus"),
                   tapAction: { })
    }
}
