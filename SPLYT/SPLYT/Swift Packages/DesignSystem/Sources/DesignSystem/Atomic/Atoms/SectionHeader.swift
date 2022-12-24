
import SwiftUI

public struct SectionHeader: View {
    private let viewState: SectionHeaderViewState
    
    public init(viewState: SectionHeaderViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        GeometryReader { proxy in
            HStack {
                Text(viewState.text)
                    .descriptionText()
                    .multilineTextAlignment(.center)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: proxy.size.height))
                    path.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height))
                }
                .frame(height: 2)
                .background(Color.gray)
                .opacity(0.5)
            }
        }
    }
}

// MARK: - ViewState

public struct SectionHeaderViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let text: String
    
    public init(id: AnyHashable = UUID(),
                text: String) {
        self.id = id
        self.text = text
    }
}
