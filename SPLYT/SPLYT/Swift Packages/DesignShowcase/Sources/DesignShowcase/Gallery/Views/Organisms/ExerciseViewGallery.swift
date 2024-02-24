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
                SectionHeader(viewState: SectionHeaderViewState(title: "Build"))
                    .foregroundColor(Color(splytColor: .lightBlue))
                    .padding(.horizontal)
                ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(title: "BACK SQUAT"),
                                                          sets: setsOne,
                                                          canRemoveSet: true,
                                                          numSetsTitle: "3 sets"
                                                         ),
                             type: .build(addModifierAction: { _ in },
                                          removeModifierAction: { _ in }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
                SectionHeader(viewState: SectionHeaderViewState(title: "In Progress"))
                    .foregroundColor(Color(splytColor: .lightBlue))
                    .padding(.horizontal)
                ExerciseView(viewState: ExerciseViewState(header: SectionHeaderViewState(title: "PUSHUPS"),
                                                          sets: setsTwo,
                                                          canRemoveSet: false,
                                                          numSetsTitle: "3 sets"
                                                         ),
                             type: .inProgress(usePreviousInputAction: { _, _ in },
                                               addNoteAction: { }),
                             addSetAction: { },
                             removeSetAction: { },
                             updateSetAction: { _, _ in },
                             updateModifierAction: { _, _ in })
            }
            .padding(.horizontal, Layout.size(2))
        }
    }
}
