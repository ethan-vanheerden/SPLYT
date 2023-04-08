import SwiftUI
import DesignSystem

struct IconButtonGallery: View {
    var body: some View {
        VStack {
            SectionHeader(viewState: SectionHeaderViewState(text: "Enabled"))
            buttons(isEnabled: true)
            SectionHeader(viewState: SectionHeaderViewState(text: "Disabled"))
            buttons(isEnabled: false)
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
    
    @ViewBuilder
    private func buttons(isEnabled: Bool) -> some View {
        VStack {
            IconButton(iconName: "plus",
                       isEnabled: isEnabled) { }
            IconButton(iconName: "minus",
                       style: .primary(backgroundColor: .red),
                       iconColor: .white,
                       isEnabled: isEnabled) { }
            IconButton(iconName: "gamecontroller",
                       style: .primary(backgroundColor: .red, outlineColor: .yellow),
                       iconColor: .green,
                       isEnabled: isEnabled) { }
            IconButton(iconName: "cloud",
                       style: .secondary,
                       iconColor: .green,
                       isEnabled: isEnabled) { }
            IconButton(iconName: "bolt.fill.",
                       style: .secondary,
                       iconColor: .yellow,
                       isEnabled: isEnabled,
                       animationEnabled: false) { }
        }
    }
}
