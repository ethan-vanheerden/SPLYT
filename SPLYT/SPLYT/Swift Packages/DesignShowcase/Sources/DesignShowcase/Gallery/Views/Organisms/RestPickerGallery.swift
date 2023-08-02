import DesignSystem
import SwiftUI

struct RestPickerGallery: View {
    @State private var minutes: Int = 2
    @State private var seconds: Int = 30
    
    var body: some View {
        RestPicker(minutes: $minutes,
                   seconds: $seconds,
                   confirmAction: { print("Confirm action") },
                   cancelAction: { print("Cancel action") })
    }
}
