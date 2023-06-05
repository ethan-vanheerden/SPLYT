import SwiftUI
import DesignSystem

struct CollapseHeaderGallery: View {
    @State private var headerOneExpanded = false
    @State private var headerTwoExpanded = false
    
    var body: some View {
        VStack {
            CollapseHeader(isExpanded: $headerOneExpanded,
                           viewState: CollapseHeaderViewState(title: "Title")) {
                Text("Hello, world!")
                    .body()
            }
            CollapseHeader(isExpanded: $headerTwoExpanded,
                           viewState: CollapseHeaderViewState(title: "Group 1",
                                                              color: .lightBlue,
                                                              isComplete: true)) {
                SetView(viewState: SetViewState(setIndex: 0,
                                                title: "Set 1",
                                                type: .repsWeight(weightTitle: "lbs",
                                                                  repsTitle: "reps",
                                                                  input: .init()),
                                                modifier: nil),
                        exerciseType: .inProgress(usePreviousInputAction: { _, _ in },
                                                  addNoteAction: { }),
                        updateSetAction: { _, _ in },
                        updateModifierAction: { _, _ in })
            }
        }
    }
}
