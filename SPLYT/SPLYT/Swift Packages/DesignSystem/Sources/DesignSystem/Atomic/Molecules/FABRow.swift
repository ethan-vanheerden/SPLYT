
import SwiftUI

public struct FABRow: View {
    private let viewState: FABRowViewState
    private let tapAction: () -> Void
    
    public init(viewState: FABRowViewState,
                tapAction: @escaping () -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
    }
    
    public var body: some View {
        HStack {
            Text(viewState.title)
                .footnote()
            FABIcon(type: fabIconType,
                    tapAction: tapAction)
        }
    }
    
    private var fabIconType: FABIconType {
        return FABIconType(size: .secondary, imageName: viewState.imageName)
    }
}

// MARK: - ViewState

public struct FABRowViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let title: String
    let imageName: String
    
    public init(id: AnyHashable = UUID(),
                title: String,
                imageName: String) {
        self.id = id
        self.title = title
        self.imageName = imageName
    }
}

struct FABRow_Previews: PreviewProvider {
    static var previews: some View {
        FABRow(viewState: FABRowViewState(title: "CREATE NEW WORKOUT", imageName: "plus"),
        tapAction: { })
    }
}
