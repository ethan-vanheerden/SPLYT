import SwiftUI
import DesignSystem
import ExerciseCore

struct BuildExerciseViewGallery: View {
    private let setsOne: [SetViewState] = [
        SetViewState(setIndex: 0,
                     title: "Set 1",
                     type: .repsWeight(weightTitle: "lbs", weight: 275, repsTitle: "reps", reps: 6),
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
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil),
        SetViewState(setIndex: 1,
                     title: "Set 2",
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil),
        SetViewState(setIndex: 2,
                     title: "Set 3",
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil)
    ]
    
    
    var body: some View {
        VStack(spacing: Layout.size(2)) {
            BuildExerciseView(viewState: BuildExerciseViewState(header: SectionHeaderViewState(text: "BACK SQUAT"),
                                                                sets: setsOne,
                                                                canRemoveSet: true),
                              addSetAction: { },
                              removeSetAction: { },
                              addModifierAction: { _ in },
                              removeModifierAction: { _ in },
                              updateSetAction: { _, _ in },
                              updateModifierAction: { _, _ in })
            BuildExerciseView(viewState: BuildExerciseViewState(header: SectionHeaderViewState(text: "PUSHUPS"),
                                                                sets: setsTwo,
                                                                canRemoveSet: false),
                              addSetAction: { },
                              removeSetAction: { },
                              addModifierAction: { _ in },
                              removeModifierAction: { _ in },
                              updateSetAction: { _, _ in },
                              updateModifierAction: { _, _ in })
        }
    }
}
