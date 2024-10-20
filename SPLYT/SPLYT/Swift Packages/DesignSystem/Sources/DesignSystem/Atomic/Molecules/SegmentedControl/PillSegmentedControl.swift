import SwiftUI

public struct PillSegmentedControl: View {
    @Binding private var selectedIndex: Int
    @EnvironmentObject private var userTheme: UserTheme
    @Environment(\.colorScheme) private var colorScheme
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
                    .foregroundStyle(Color(textColor(titleIndex: titleIndex)))
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
                        .animation(.smooth(duration: 0.25), value: selectedIndex)
                    }
                    .onTapGesture {
                        guard selectedIndex != titleIndex else {
                            return
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedIndex = titleIndex
                    }
            }
        }
        .background(Color(SplytColor.gray).gradient.opacity(0.2), in: .capsule)
    }
    
    private func textColor(titleIndex: Int) -> SplytColor {
        if titleIndex == selectedIndex {
            return .white
        } else if colorScheme == .light {
            return .black
        } else {
            return .gray
        }
    }
    
    private func leadingPadding(index: Int) -> CGFloat? {
        return index == 0 ? horizontalPadding : nil
    }
}
