import SwiftUI

public struct MenuItem: View {
    private let viewState: MenuItemViewState
    private let tapAction: (MenuItemViewState) -> Void
    @State private var isPressed: Bool = false
    private let cellHeight = Layout.size(6)
    
    public init(viewState: MenuItemViewState,
                tapAction: @escaping (MenuItemViewState) -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
    }
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(viewState.title)
                    .body()
                    .foregroundColor(isPressed ? .blue : .black)
                subtitleView
                Spacer()
            }
            .padding(.leading, Layout.size(2))
            Spacer()
        }
        .frame(height: cellHeight)
        .roundedBackground(cornerRadius: Layout.size(1.5), fill: Color(splytColor: .gray).opacity(0.1))
        .gesture(press)
        .padding(.horizontal, Layout.size(2))
    }
    
    @ViewBuilder
    private var subtitleView: some View {
        if let subtitle = viewState.subtitle {
            Text(subtitle)
                .footnote()
                .foregroundColor(Color(splytColor: .lightBlue))
        } else {
            EmptyView()
        }
    }
    
    /// Changes the text color when we press a cell. Also only selects the item if where we release is close enough to where we tapped.
    private var press: some Gesture {
        DragGesture(minimumDistance: .zero)
            .onChanged { _ in
                isPressed = true
            }
            .onEnded { value in
                let height = abs(value.translation.height)
                if cellHeight - height > 0  {
                    tapAction(viewState)
                }
                isPressed = false
            }
    }
}


// MARK: View State

public struct MenuItemViewState: Equatable {
    public let id: AnyHashable
    let title: String
    let subtitle: String?
    
    public init(id: AnyHashable = UUID(),
                title: String,
                subtitle: String? = nil) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}
