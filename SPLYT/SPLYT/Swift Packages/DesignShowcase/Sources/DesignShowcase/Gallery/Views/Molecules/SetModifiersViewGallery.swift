import SwiftUI
import DesignSystem

struct SetModifiersViewGallery: View {
    var body: some View {
        SetModifiersView { setModifier in
            print("Selected Modifier: \(setModifier.title)")
        }
    }
}
