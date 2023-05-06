import SwiftUI
import DesignSystem

struct StopwatchViewGallery: View {
    @State private var secondsOne = 0
    @State private var secondsTwo = 3600
    var body: some View {
        VStack {
            Spacer()
            StopwatchView(secondsElapsed: $secondsOne)
            StopwatchView(secondsElapsed: $secondsTwo)
            Spacer()
        }
    }
}
