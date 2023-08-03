import DesignSystem
import SwiftUI

struct RestPickerGallery: View {
    @State private var minutes: Int = 2
    @State private var seconds: Int = 30
    
    var body: some View {
        VStack {
            Spacer()
            RestPicker(minutes: $minutes,
                       seconds: $seconds,
                       confirmAction: { print("Confirm action - Min: \(minutes), Sec: \(seconds)") },
                       cancelAction: { print("Cancel action") })
            Spacer()
        }
    }
}
