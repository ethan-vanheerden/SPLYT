import SwiftUI
import DesignSystem

struct RestFABRowGallery: View {
    var body: some View {
        VStack {
            Spacer()
            RestFABRow(seconds: 30, tapAction: { })
            RestFABRow(seconds: 60, tapAction: { })
            RestFABRow(seconds: 150, tapAction: { })
            Spacer()
        }
    }
}
