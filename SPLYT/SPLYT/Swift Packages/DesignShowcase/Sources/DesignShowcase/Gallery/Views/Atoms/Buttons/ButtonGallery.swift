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
            SplytButton(text: "Primary Button",
                        isEnabled: isEnabled) { print("Button tapped!") }
            HStack(spacing: Layout.size(2)) {
                Spacer()
                SplytButton(text: "cancel",
                            type: .primary(color: .red),
                            textColor: .black,
                            isEnabled: isEnabled) { print("Button tapped!") }
                SplytButton(text: "Confirm",
                            type: .primary(color: .green),
                            isEnabled: isEnabled) { print("Button tapped!") }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        type: .secondary(),
                        isEnabled: isEnabled) { print("Button tapped!") }
            SplytButton(text: "Button no animations",
                        type: .primary(color: .white),
                        textColor: .black,
                        isEnabled: isEnabled,
                        animationEnabled: false) { print("Button tapped!") }
            SplytButton(text: "Text Only",
                        type: .textOnly(fillsSpace: true),
                        textColor: .lightBlue,
                        isEnabled: isEnabled) { print("Button tapped!") }
            SplytButton(text: "",
                        type: .loading(color: .blue),
                        isEnabled: false) { print("Button tapped!") }
        }
    }
}
