import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI
import ExerciseCore

final class SetViewTests: XCTestCase {
    private let viewStateOne = SetViewState(setIndex: 0,
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              repsTitle: "reps",
                                                              input: RepsWeightInput(weight: 135)),
                                            modifier: .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps")))
    private let viewStateTwo = SetViewState(setIndex: 1,
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              repsTitle: "reps",
                                                              input: RepsWeightInput(weight: 225,
                                                                                     reps: 8)),
                                            modifier: .restPause(set: .repsOnly(title: "reps")))
    private let viewStateThree = SetViewState(setIndex: 2,
                                              title: "Set 3",
                                              type: .repsOnly(title: "reps",
                                                              input: RepsOnlyInput(reps: 8)),
                                              modifier: .eccentric)
    private let viewStateFour = SetViewState(setIndex: 3,
                                             title: "Set 4",
                                             type: .time(title: "sec",
                                                         input: TimeInput(seconds: 30)))
    private let viewStateFive = SetViewState(setIndex: 4,
                                             title: "Set 5",
                                             type: .repsOnly(title: "reps",
                                                             input: RepsOnlyInput(placeholder: 8)))
    private let viewStateSix = SetViewState(setIndex: 5,
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps"))
    
    func testSetView() {
        let view = VStack {
            SetView(viewState: viewStateOne,
                    exerciseType: .build(addModifierAction: { _ in },
                                         removeModifierAction: { _ in }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: viewStateTwo,
                    exerciseType: .build(addModifierAction: { _ in },
                                         removeModifierAction: { _ in }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: viewStateThree,
                    exerciseType: .build(addModifierAction: { _ in },
                                         removeModifierAction: { _ in }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: viewStateFour,
                    exerciseType: .build(addModifierAction: { _ in },
                                         removeModifierAction: { _ in }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: viewStateFive,
                    exerciseType: .inProgress(usePreviousInputAction: { _, _ in },
                                              addNoteAction: { }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: viewStateSix,
                    exerciseType: .inProgress(usePreviousInputAction: { _, _ in },
                                              addNoteAction: { }),
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in })
        }
        .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
