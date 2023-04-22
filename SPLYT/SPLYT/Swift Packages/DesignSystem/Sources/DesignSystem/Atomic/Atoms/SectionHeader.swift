import SwiftUI

public struct SectionHeader: View {
    private let viewState: SectionHeaderViewState
    private let lineHeight = Layout.size(0.25)
    
    public init(viewState: SectionHeaderViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        HStack {
            Text(viewState.text)
                .body()
                .multilineTextAlignment(.center)
            GeometryReader { proxy in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: proxy.size.height))
                    path.addLine(to: CGPoint(x: proxy.size.width, y: proxy.size.height))
                }
                .frame(height: lineHeight)
                .background(Color(splytColor: .gray))
                .opacity(0.5)
            }
            .frame(height: lineHeight)
        }
    }
}

// MARK: - ViewState

public struct SectionHeaderViewState: Equatable {
    let text: String
    
    public init(text: String) {
        self.text = text
    }
}
