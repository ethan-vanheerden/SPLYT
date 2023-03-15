
import SwiftUI
import DesignSystem

struct TabBarGallery: View {
    @State private var selectedTab: TabType = .home
    
    var body: some View {
        VStack {
            Spacer()
            TabBar(selectedTab: $selectedTab)
        }
    }
}
