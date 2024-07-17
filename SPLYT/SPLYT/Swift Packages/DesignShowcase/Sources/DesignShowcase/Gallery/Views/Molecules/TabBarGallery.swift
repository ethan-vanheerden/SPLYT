
import SwiftUI
import DesignSystem

struct TabBarGallery: View {
    @State private var selectedTab: TabSelection = .home
    
    var body: some View {
        VStack {
            Spacer()
            TabBar(selectedTab: $selectedTab)
        }
    }
}
