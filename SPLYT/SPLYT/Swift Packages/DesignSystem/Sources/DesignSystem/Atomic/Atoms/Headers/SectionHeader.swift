import SwiftUI

public struct SectionHeader: View {
    private let viewState: SectionHeaderViewState
    private let lineHeight = Layout.size(0.25)
    
    public init(viewState: SectionHeaderViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        HStack {
            Text(viewState.title)
                .body()
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            if viewState.includeLine {
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
            } else {
                Spacer()
            }
        }
    }
}

// MARK: - ViewState

public struct SectionHeaderViewState: Equatable, Hashable {
    fileprivate let title: String
    fileprivate let includeLine: Bool
    
    public init(title: String,
                includeLine: Bool = true) {
        self.title = title
        self.includeLine = includeLine
    }
}
