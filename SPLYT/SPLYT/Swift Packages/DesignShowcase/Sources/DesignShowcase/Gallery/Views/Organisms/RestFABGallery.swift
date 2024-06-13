import SwiftUI
import DesignSystem

struct RestFABGallery: View {
    @State private var isPresenting = false
    private let restPresets: [Int] = [60, 90, 120]
    
    var body: some View {
        VStack {
            SectionHeader(viewState: .init(title: "Resting"))
                .padding(.horizontal, Layout.size(2))
            RestFAB(isPresenting: $isPresenting,
                    workoutSeconds: .constant(0),
                    viewState: viewState(isResting: true),
                    selectRestAction: { print($0) },
                    stopRestAction: { },
                    pauseAction: { print("paused") },
                    resumeAction: { print("resumed with \($0) seconds") })
            SectionHeader(viewState: .init(title: "Not Resting"))
                .padding(.horizontal, Layout.size(2))
            RestFAB(isPresenting: $isPresenting,
                    workoutSeconds: .constant(0),
                    viewState: viewState(isResting: false),
                    selectRestAction: { print($0) },
                    stopRestAction: { },
                    pauseAction: { print("paused") },
                    resumeAction: { print("resumed with \($0) seconds") })
        }
    }
    
    private func viewState(isResting: Bool) -> RestFABViewState {
        return RestFABViewState(isResting: isResting,
                                restPresets: restPresets)
    }
}
