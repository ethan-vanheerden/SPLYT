import SwiftUI
import DesignSystem

struct ButtonGallery: View {
    var body: some View {
        VStack {
            Spacer()
            SplytButton(text: "BUTTON TEXT") { print("Button tapped!") }
            HStack {
                Spacer()
                SplytButton(text: "cancel",
                            color: .red,
                            textColor: .black) { print("Button tapped!") }
                SplytButton(text: "Confirm",
                            color: .green) { print("Button tapped!") }
                Spacer()
            }
            Spacer()
        }
    }
}
