import SwiftUI
import DesignSystem

struct CompletedSetViewGallery: View {
    private let viewStateOne = CompletedSetViewState(title: "Set 1",
                                                     type: .repsOnly(title: "reps",
                                                                     input: .init(reps: 10)))
    private let viewStateTwo = CompletedSetViewState(title: "Set 2",
                                                     type: .time(title: "sec",
                                                                 input: .init(seconds: 60)))
    private let viewStateThree = CompletedSetViewState(title: "Set 3",
                                                       type: .repsWeight(weightTitle: "lbs",
                                                                         repsTitle: "reps",
                                                                         input: .init(weight: 135, reps: 12)))
    private let viewStateFour = CompletedSetViewState(title: "Set 4",
                                                      type: .repsWeight(weightTitle: "lbs",
                                                                        repsTitle: "reps",
                                                                        input: .init(weight: 225, reps: 8)),
                                                      modifier: .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                                          repsTitle: "reps",
                                                                                          input: .init(weight: 100, reps: nil))))
    private let viewStateFive = CompletedSetViewState(title: "Set 5",
                                                      type: .repsWeight(weightTitle: "lbs",
                                                                        repsTitle: "reps",
                                                                        input: .init(weight: 225, reps: 8)),
                                                      modifier: .eccentric)
    private let viewStateSix = CompletedSetViewState(title: "Set 6",
                                                     type: .repsOnly(title: "reps",
                                                                     input: .init(reps: 10)),
                                                     modifier: .restPause(set: .repsOnly(title: "reps",
                                                                                         input: .init())))
    
    var body: some View {
        VStack(spacing: Layout.size(1)) {
            CompletedSetView(viewState: viewStateOne)
            CompletedSetView(viewState: viewStateTwo)
            CompletedSetView(viewState: viewStateThree)
            CompletedSetView(viewState: viewStateFour)
            CompletedSetView(viewState: viewStateFive)
            CompletedSetView(viewState: viewStateSix)
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
