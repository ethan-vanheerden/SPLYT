
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

public struct FABRowViewState: Equatable {
    let title: String
    let imageName: String
    
    public init(title: String,
                imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

// MARK: - Row Type

public enum FABRowType: Equatable {
    case icon(title: String?, imageName: String)
    case time(seconds: Int)
}

struct FABRow_Previews: PreviewProvider {
    static var previews: some View {
        FABRow(viewState: FABRowViewState(title: "CREATE NEW WORKOUT", imageName: "plus"),
        tapAction: { })
    }
}
