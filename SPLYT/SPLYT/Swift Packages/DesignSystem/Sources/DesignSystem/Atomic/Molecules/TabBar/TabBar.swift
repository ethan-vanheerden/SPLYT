import SwiftUI

public struct TabBar: View {
    @Binding private var selectedTab: TabType
    private let iconLength = Layout.size(3.25)
    
    public init(selectedTab: Binding<TabType>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack {
            ForEach(TabType.allCases, id: \.self) { tab in
                Spacer()
                tabView(tab: tab)
                    .onTapGesture {
                        selectedTab = tab
                    }
                    .foregroundColor(iconColor(tab: tab))
                Spacer()
            }
            .padding(.top, Layout.size(0.5))
        }
        .background() // Keeps the background consistent with dark/light mode
    }
    
    private func iconColor(tab: TabType) -> Color {
        return tab == selectedTab ? Color(splytColor: .lightBlue) : Color(splytColor: .gray)
    }
    
    @ViewBuilder
    private func tabView(tab: TabType) -> some View {
        VStack(spacing: .zero) {
            Image(systemName: tab.imageName(isSelected: selectedTab == tab))
                .padding(.bottom, Layout.size(0.25))
            Text(tab.title)
                .footnote(style: .semiBold)
        }
        .frame(width: Layout.size(10)) // Fixed height so properly centered
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(selectedTab: .constant(.home))
    }
}
