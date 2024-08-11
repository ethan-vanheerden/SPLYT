import SwiftUI
import DesignSystem
import ExerciseCore

struct ExerciseViewGallery: View {
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
        SetViewState(setIndex: 3,
                     title: "Set 4",
                     type: .repsWeight(weightTitle: "lbs", repsTitle: "reps"),
                     modifier: nil),
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
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: Layout.size(2)) {
                SectionHeader(viewState: SectionHeaderViewState(title: "Build"))
                    .padding(.horizontal)
                ExerciseView(arguments: .regular(
                    viewState: ExerciseViewState(header: SectionHeaderViewState(title: "BACK SQUAT"),
                                                 sets: setsOne,
                                                 canRemoveSet: true,
                                                 numSetsTitle: "3 sets"
                                                ),
                    type: .build,
                    addSetAction: { },
                    removeSetAction: { },
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in }))
                SectionHeader(viewState: SectionHeaderViewState(title: "In Progress"))
                    .padding(.horizontal)
                ExerciseView(arguments: .regular(
                    viewState: ExerciseViewState(header: SectionHeaderViewState(title: "PUSHUPS"),
                                                 sets: setsTwo,
                                                 canRemoveSet: false,
                                                 numSetsTitle: "3 sets"
                                                ),
                    type: .inProgress(usePreviousInputAction: { _, _ in },
                                      addNoteAction: { },
                                      replaceExerciseAction: { },
                                      deleteExerciseAction: { },
                                      canDeleteExercise: true),
                    addSetAction: { },
                    removeSetAction: { },
                    updateSetAction: { _, _ in },
                    updateModifierAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in }))
                SectionHeader(viewState: .init(title: "Loading"))
                    .padding(.horizontal)
                ExerciseView(arguments: .loading)
            }
            .padding(.horizontal, Layout.size(2))
        }
    }
}
