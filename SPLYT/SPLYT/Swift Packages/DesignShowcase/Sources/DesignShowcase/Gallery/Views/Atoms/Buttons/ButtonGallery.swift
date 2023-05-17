import SwiftUI
import DesignSystem

struct ButtonGallery: View {
    var body: some View {
        VStack {
            SectionHeader(viewState: SectionHeaderViewState(title: "Enabled"))
            buttons(isEnabled: true)
            SectionHeader(viewState: SectionHeaderViewState(title: "Disabled"))
            buttons(isEnabled: false)
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
    
    @ViewBuilder
    private func buttons(isEnabled: Bool) -> some View {
        VStack {
            SplytButton(text: "BUTTON TEXT",
                        isEnabled: isEnabled) { print("Button tapped!") }
            HStack(spacing: Layout.size(2)) {
                Spacer()
                SplytButton(text: "cancel",
                            color: .red,
                            textColor: .black,
                            isEnabled: isEnabled) { print("Button tapped!") }
                SplytButton(text: "Confirm",
                            color: .green,
                            isEnabled: isEnabled) { print("Button tapped!") }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        size: .secondary,
                        isEnabled: isEnabled) { print("Button tapped!") }
            SplytButton(text: "Button no animations",
                        size: .primary,
                        color: .white,
                        textColor: .black,
                        outlineColor: .black,
                        isEnabled: isEnabled,
                        animationEnabled: false) { print("Button tapped!") }
        }
    }
}
