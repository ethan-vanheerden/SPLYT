import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI
import ExerciseCore

final class ExerciseViewTests: XCTestCase {
    private let setsOne: [SetViewState] = [
        SetViewState(setIndex: 0,
                     title: "Set 1",
                     type: .repsWeight(weightTitle: "lbs",
                                       repsTitle: "reps",
                                       input: RepsWeightInput(weight: 275, reps: 6)),
                     modifier: .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps"))),
        SetViewState(setIndex: 1,
                     title: "Set 2",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     modifier: .restPause(set: .repsOnly(title: "reps"))),
        SetViewState(setIndex: 2,
                     title: "Set 3",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     modifier: .eccentric),
    ]
    
    private let setsTwo: [SetViewState] = [
        SetViewState(setIndex: 0,
                     title: "Set 1",
                     type: .repsOnly(title: "reps",
                                     input: RepsOnlyInput(reps: 15)),
                     modifier: nil),
        SetViewState(setIndex: 1,
                     title: "Set 2",
                     type: .repsOnly(title: "reps",
                                     input: RepsOnlyInput(placeholder: 10)),
                     modifier: nil),
        SetViewState(setIndex: 2,
                     title: "Set 3",
                     type: .repsOnly(title: "reps"),
                     modifier: nil)
    ]
    
    func testExerciseView_Build() {
        let view = VStack {
            ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(title: "BACK SQUAT"),
                                                      sets: setsOne,
                                                      canRemoveSet: true,
                                                      numSetsTitle: "3 sets"),
                         type: .build(addModifierAction: { _ in }, removeModifierAction: { _ in }),
                         addSetAction: { },
                         removeSetAction: { },
                         updateSetAction: { _, _ in },
                         updateModifierAction: { _, _ in })
        }
            .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testExerciseView_InProgress() {
        let view = VStack {
            ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(title: "PUSHUPS"),
                                                      sets: setsTwo,
                                                      canRemoveSet: false,
                                                      numSetsTitle: "3 sets"),
                         type: .inProgress(usePreviousInputAction: { _, _ in }, addNoteAction: { }),
                         addSetAction: { },
                         removeSetAction: { },
                         updateSetAction: { _, _ in },
                         updateModifierAction: { _, _ in })
        }
            .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
