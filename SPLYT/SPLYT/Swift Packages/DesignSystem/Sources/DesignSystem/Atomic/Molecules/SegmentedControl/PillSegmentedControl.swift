import SwiftUI

public struct PillSegmentedControl: View {
    @Binding private var selectedIndex: Int
    @EnvironmentObject private var userTheme: UserTheme
    @Namespace private var animation
    private let titles: [String]
    private let horizontalPadding = Layout.size(2)
    private let geoId = "SEGMENTED_CONTROL"
    
    public init(selectedIndex: Binding<Int>, titles: [String]) {
        self._selectedIndex = selectedIndex
        self.titles = titles
    }
    
    public var body: some View {
        HStack {
            ForEach(Array(titles.enumerated()), id: \.offset) { titleIndex, title in
                Text(title)
                    .subhead()
                    .foregroundStyle(titleIndex == selectedIndex ? Color(SplytColor.white) : Color(SplytColor.black))
                    .animation(.easeOut, value: selectedIndex)
                    .padding(.vertical, Layout.size(1))
                    .padding(.leading, leadingPadding(index: titleIndex))
                    .padding(.trailing, horizontalPadding)
                    .background {
                        ZStack {
                            if titleIndex == selectedIndex {
                                Capsule().fill(Color(userTheme.theme).gradient)
                                    .matchedGeometryEffect(id: geoId, in: animation)
                            }
                        }
                        .animation(.snappy, value: selectedIndex)
                    }
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedIndex = titleIndex
                    }
            }
        }
        .background(Color(SplytColor.gray50).opacity(0.2).gradient, in: .capsule)
    }
    
    private func leadingPadding(index: Int) -> CGFloat? {
        return index == 0 ? horizontalPadding : nil
    }
}
