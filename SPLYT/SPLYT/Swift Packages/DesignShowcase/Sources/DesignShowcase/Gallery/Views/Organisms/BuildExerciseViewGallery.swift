import SwiftUI
import DesignSystem
import ExerciseCore

struct BuildExerciseViewGallery: View {
    private let setsOne: [SetViewState] = [
        SetViewState(id: "set-1",
                     title: "Set 1",
                     type: .repsWeight(weightTitle: "lbs", weight: 275, repsTitle: "reps", reps: 6),
                     modifier: SetModifierViewState(id: "set-1-modifier", type: .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps")))),
        SetViewState(id: "set-2",
                     title: "Set 2",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     modifier: SetModifierViewState(id: "set-2-modifier", type: .restPause(set: .repsOnly(title: "reps")))),
        SetViewState(id: "set-3",
                     title: "Set 3",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     modifier: SetModifierViewState(id: "set-3-modifier", type: .eccentric)),
    ]
    
    private let setsTwo: [SetViewState] = [
        SetViewState(id: "set-4",
                     title: "Set 1",
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil),
        SetViewState(id: "set-5",
                     title: "Set 2",
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil),
        SetViewState(id: "set-6",
                     title: "Set 3",
                     type: .repsOnly(title: "reps", reps: 15),
                     modifier: nil)
    ]
    
    
    var body: some View {
        VStack(spacing: Layout.size(2)) {
            BuildExerciseView(viewState: BuildExerciseViewState(id: "exercise-1",
                                                                header: SectionHeaderViewState(text: "BACK SQUAT"),
                                                                sets: setsOne,
                                                                canRemoveSet: true),
                              addSetAction: { },
                              removeSetAction: { },
                              addModifierAction: { _ in },
                              removeModifierAction: { _ in },
                              updateAction: { _, _ in })
            BuildExerciseView(viewState: BuildExerciseViewState(id: "exercise-2",
                                                                header: SectionHeaderViewState(text: "PUSHUPS"),
                                                                sets: setsTwo,
                                                                canRemoveSet: false),
                              addSetAction: { },
                              removeSetAction: { },
                              addModifierAction: { _ in },
                              removeModifierAction: { _ in },
                              updateAction: { _, _ in })
        }
    }
}
