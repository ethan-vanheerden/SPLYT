import SwiftUI

public struct TabBar: View {
    @Binding private var selectedTab: TabSelection
    @EnvironmentObject private var userTheme: UserTheme
    private let iconLength = Layout.size(3.25)
    
    public init(selectedTab: Binding<TabSelection>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack {
            ForEach(TabSelection.allCases, id: \.self) { tab in
                Spacer()
                tabView(tab: tab)
                    .onTapGesture {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedTab = tab
                    }
                    .foregroundStyle(iconColor(tab: tab).gradient)
                Spacer()
            }
            .padding(.top, Layout.size(0.5))
        }
        .background(Color(SplytColor.background).shadow(.drop(radius: Layout.size(0.125))))
    }
    
    private func iconColor(tab: TabSelection) -> Color {
        return tab == selectedTab ? Color(userTheme.theme) : Color(SplytColor.gray)
    }
    
    @ViewBuilder
    private func tabView(tab: TabSelection) -> some View {
        VStack(spacing: .zero) {
            Image(systemName: tab.imageName)
                .padding(.bottom, Layout.size(0.25))
            Text(tab.title)
                .footnote(style: .semiBold)
        }
        .padding(.vertical, Layout.size(0.5))
        .foregroundStyle(iconColor(tab: tab))
        .frame(width: Layout.size(10)) // Fixed so properly centered
    }
}
