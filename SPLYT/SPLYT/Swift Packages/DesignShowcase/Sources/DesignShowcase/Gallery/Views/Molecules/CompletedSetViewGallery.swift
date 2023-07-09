import SwiftUI
import DesignSystem

struct CompletedSetViewGallery: View {
    var body: some View {
        Tile {
            VStack(spacing: Layout.size(1)) {
                CompletedSetView(viewState: .init(title: "Set 1",
                                                   type: .repsOnly(title: "reps",
                                                                   input: .init(reps: 10)),
                                                  progression: .positive))
                CompletedSetView(viewState: .init(title: "Set 2",
                                                  type: .time(title: "sec",
                                                              input: .init(seconds: 60)),
                                                  progression: .negative))
                CompletedSetView(viewState: .init(title: "Set 3",
                                                  type: .repsWeight(weightTitle: "lbs",
                                                                    repsTitle: "reps",
                                                                    input: .init(weight: 135, reps: 12)),
                                                  progression: .neutral))
                CompletedSetView(viewState: .init(title: "Set 4",
                                                  type: .repsWeight(weightTitle: "lbs",
                                                                    repsTitle: "reps",
                                                                    input: .init(weight: 225, reps: 8)),
                                                  modifier: .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                                      repsTitle: "reps",
                                                                                      input: .init(weight: 100, reps: nil)))))
                CompletedSetView(viewState: .init(title: "Set 4",
                                                  type: .repsWeight(weightTitle: "lbs",
                                                                    repsTitle: "reps",
                                                                    input: .init(weight: 225, reps: 8)),
                                                  modifier: .eccentric))
                CompletedSetView(viewState: .init(title: "Set 1",
                                                  type: .repsOnly(title: "reps",
                                                                  input: .init(reps: 10)),
                                                  modifier: .restPause(set: .repsOnly(title: "reps",
                                                                                      input: .init()))))
            }
        }
        .padding(.horizontal, Layout.size(2))
    }
}
