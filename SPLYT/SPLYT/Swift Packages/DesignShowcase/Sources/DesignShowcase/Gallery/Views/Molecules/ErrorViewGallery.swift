import SwiftUI
import DesignSystem

struct ErrorViewGallery: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ErrorView()
            ErrorView(retryAction: {},
                      backAction: { dismiss() })
        }
    }
}
