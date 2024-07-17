import SwiftUI

public struct TabBar: View {
    @Binding private var selectedTab: TabSelection
    @EnvironmentObject private var userTheme: UserTheme
    @Namespace private var animation
    private let iconLength = Layout.size(3.25)
    private let geoId = "TAB_BAR"
    
    public init(selectedTab: Binding<TabSelection>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack {
            ForEach(TabSelection.allCases, id: \.self) { tab in
                Spacer()
                tabView(tab: tab)
                    .onTapGesture {
                        selectedTab = tab
                    }
                    .foregroundStyle(iconColor(tab: tab).gradient)
                Spacer()
            }
        }
        .padding(.vertical, Layout.size(1.5))
        .background(Color(SplytColor.white), in: .capsule)
//        .roundedBackground(cornerRadius: Layout.size(4),
//                           fill: Color(SplytColor.white).shadow(.drop(radius: Layout.size(0.25))))
    }
    
    private func iconColor(tab: TabSelection) -> Color {
        return tab == selectedTab ? Color( userTheme.theme) : Color(SplytColor.gray)
    }
    
    @ViewBuilder
    private func tabView(tab: TabSelection) -> some View {
        VStack(spacing: .zero) {
            Image(systemName: tab.imageName)
                .padding(.bottom, Layout.size(0.25))
            Text(tab.title)
                .footnote(style: .semiBold)
        }
        .frame(width: Layout.size(10)) // Fixed so properly centered
    }
}
