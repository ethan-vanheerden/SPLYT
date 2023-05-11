//import XCTest
//import DesignSystem
//import SnapshotTesting
//import SwiftUI
//
//final class ExerciseViewTests: XCTestCase {
//    private let setsOne: [SetViewState] = [
//        SetViewState(setIndex: 0,
//                     title: "Set 1",
//                     type: .repsWeight(weightTitle: "lbs", weight: 275, repsTitle: "reps", reps: 6)),
//        SetViewState(setIndex: 1,
//                     title: "Set 2",
//                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps")),
//        SetViewState(setIndex: 2,
//                     title: "Set 3",
//                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
//                     modifier: .dropSet(set: .repsWeight(weightTitle: "lbs",
//                                                         weight: 100,
//                                                         repsTitle: "reps"))),
//    ]
//
//    private let setsTwo: [SetViewState] = [
//        SetViewState(setIndex: 0,
//                     title: "Set 1",
//                     type: .repsOnly(title: "reps", reps: 15)),
//        SetViewState(setIndex: 1,
//                     title: "Set 2",
//                     type: .repsOnly(title: "reps", reps: 15),
//                     modifier: .eccentric),
//        SetViewState(setIndex: 2,
//                     title: "Set 3",
//                     type: .repsOnly(title: "reps", reps: 15))
//    ]
//
//    func testExerciseView() {
//        let view = VStack(spacing: Layout.size(2)) {
//            ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(text: "BACK SQUAT"),
//                                                                sets: setsOne,
//                                                                canRemoveSet: true),
//                              addSetAction: { },
//                              removeSetAction: { },
//                              addModifierAction: { _ in },
//                              removeModifierAction: { _ in },
//                              updateSetAction: { _, _ in },
//                              updateModifierAction: { _, _ in })
//            ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(text: "PUSHUPS"),
//                                                                sets: setsTwo,
//                                                                canRemoveSet: false),
//                              addSetAction: { },
//                              removeSetAction: { },
//                              addModifierAction: { _ in },
//                              removeModifierAction: { _ in },
//                              updateSetAction: { _, _ in },
//                              updateModifierAction: { _, _ in })
//        }
//        let vc = UIHostingController(rootView: view)
//        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
//    }
//}
