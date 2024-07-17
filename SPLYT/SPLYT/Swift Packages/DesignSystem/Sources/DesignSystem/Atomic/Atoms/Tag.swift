import SwiftUI

public struct Tag: View {
    private let viewState: TagViewState
    
    public init(viewState: TagViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            Text(viewState.title)
                .footnote()
                .padding(Layout.size(0.5))
                .foregroundColor(.white)
                .roundedBackground(cornerRadius: Layout.size(1),
                                   fill: Color( viewState.color)
                    .gradient
                    .shadow(.drop(radius: Layout.size(0.5))))
        }
    }
}

// MARK: - ViewState

public struct TagViewState: Equatable {
    let title: String
    let color: SplytColor
    
    public init(title: String,
                color: SplytColor) {
        self.title = title
        self.color = color
    }
}
