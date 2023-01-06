
import SwiftUI

public struct NavigationBar: View {
    private let viewState: NavigationBarViewState
    private let dismissAction: (() -> Void)?
    
    public init(viewState: NavigationBarViewState,
                dismissAction: (() -> Void)? = nil) {
        self.viewState = viewState
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        HStack {
            if let dismissAction = dismissAction {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.backward")
                        .tint(Color.black)
                }
            }
            Text(viewState.title)
                .titleText()
            Spacer()
        }
    }
}


struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(viewState: NavigationBarViewState(title: "Title"), dismissAction: { })
    }
}


// MARK: - ViewState

public struct NavigationBarViewState: Equatable, ItemViewState {
    public let id: AnyHashable
    let title: String
    
    public init(id: AnyHashable = UUID(),
                title: String) {
        self.id = id
        self.title = title
    }
}
