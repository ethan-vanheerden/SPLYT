import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI
import ExerciseCore

final class CompletedExerciseViewTests: XCTestCase {
    private let sets: [CompletedSetViewState] = [
        CompletedSetViewState(title: "Set 1",
                              type: .repsOnly(title: "reps",
                                              input: .init(reps: 10))),
        CompletedSetViewState(title: "Set 2",
                              type: .time(title: "sec",
                                          input: .init(seconds: 60))),
        CompletedSetViewState(title: "Set 3",
                              type: .repsWeight(weightTitle: "lbs",
                                                repsTitle: "reps",
                                                input: .init(weight: 135, reps: 12))),
        CompletedSetViewState(title: "Set 4",
                              type: .repsWeight(weightTitle: "lbs",
                                                repsTitle: "reps",
                                                input: .init(weight: 225, reps: 8)),
                              modifier: .dropSet(set: .repsWeight(weightTitle: "lbs",
                                                                  repsTitle: "reps",
                                                                  input: .init(weight: 100, reps: nil)))),
        CompletedSetViewState(title: "Set 5",
                              type: .repsWeight(weightTitle: "lbs",
                                                repsTitle: "reps",
                                                input: .init(weight: 225, reps: 8)),
                              modifier: .eccentric),
        CompletedSetViewState(title: "Set 6",
                              type: .repsOnly(title: "reps",
                                              input: .init(reps: 10)),
                              modifier: .restPause(set: .repsOnly(title: "reps",
                                                                  input: .init())))
    ]
    
    func testCompletedExerciseView() {
        let view = CompletedExerciseView(viewState: .init(header: .init(title: "Back Squat"),
                                                          sets: sets))
            .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
