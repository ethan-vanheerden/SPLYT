import SwiftUI
import DesignSystem

struct BuildExerciseViewGallery: View {
    private let setsOne: [SetViewState] = [
        SetViewState(id: "set-1",
                     title: "Set 1",
                     type: .repsWeight(weightTitle: "lbs", weight: 275, repsTitle: "reps", reps: 6),
                     tag: nil),
        SetViewState(id: "set-2",
                     title: "Set 2",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     tag: nil),
        SetViewState(id: "set-3",
                     title: "Set 3",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     tag: .dropSet),
    ]
    
    private let setsTwo: [SetViewState] = [
        SetViewState(id: "set-4",
                     title: "Set 1",
                     type: .repsOnly(title: "reps", reps: 15),
                     tag: nil),
        SetViewState(id: "set-5",
                     title: "Set 2",
                     type: .repsOnly(title: "reps", reps: 15),
                     tag: .eccentric),
        SetViewState(id: "set-6",
                     title: "Set 3",
                     type: .repsOnly(title: "reps", reps: 15),
                     tag: nil)
    ]
    
    
    var body: some View {
        VStack(spacing: Layout.size(2)) {
            BuildExerciseView(viewState: BuildExerciseViewState(id: "exercise-1",
                                                                header: SectionHeaderViewState(text: "BACK SQUAT"),
                                                                sets: setsOne),
                              addSetAction: { },
                              removeSetAction: { },
                              addModiferAction: { },
                              updateAction: { _, _ in })
            BuildExerciseView(viewState: BuildExerciseViewState(id: "exercise-2",
                                                                header: SectionHeaderViewState(text: "PUSHUPS"),
                                                                sets: setsTwo),
                              addSetAction: { },
                              removeSetAction: { },
                              addModiferAction: { },
                              updateAction: { _, _ in })
        }
    }
}
