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
                SectionHeader(viewState: SectionHeaderViewState(text: "Build"))
                    .padding(.horizontal)
                ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(text: "BACK SQUAT"),
                                                          sets: setsOne,
                                                          canRemoveSet: true),
                             type: .build(addModifierAction: { _ in }, removeModifierAction: { _ in }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
                SectionHeader(viewState: SectionHeaderViewState(text: "In Progress"))
                    .padding(.horizontal)
                ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(text: "PUSHUPS"),
                                                          sets: setsTwo,
                                                          canRemoveSet: false),
                             type: .inProgress(usePreviousAction: { _ in }, addNoteAction: { }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
            }
        }
    }
}
