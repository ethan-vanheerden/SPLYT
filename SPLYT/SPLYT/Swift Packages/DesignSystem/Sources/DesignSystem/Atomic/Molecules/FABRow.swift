
import SwiftUI

public struct FABRow: View {
    private let viewState: FABRowViewState
//    private let tapAction: () -> Void
    
    public init(viewState: FABRowViewState) {
        self.viewState = viewState
//        self.tapAction = tapAction
    }
    
    public var body: some View {
        HStack(spacing: Layout.size(1)) {
            Text(viewState.title)
                .bodyText()
            FABIcon(type: fabIconType)
                .onTapGesture {
                    viewState.tapAction()
                }
        }
    }
    
    private var fabIconType: FABIconType {
        return FABIconType(size: .secondary, imageName: viewState.imageName)
    }
}

// MARK: - ViewState

public struct FABRowViewState: ItemViewState {
    public let id: AnyHashable
    let title: String
    let imageName: String
    let tapAction: () -> Void
    
    public init(id: AnyHashable = UUID(),
                title: String,
                imageName: String,
                tapAction: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.imageName = imageName
        self.tapAction = tapAction
    }
    
}

struct FABRow_Previews: PreviewProvider {
    static var previews: some View {
        FABRow(viewState: FABRowViewState(title: "CREATE NEW WORKOUT", imageName: "plus", tapAction: {}))
    }
}
