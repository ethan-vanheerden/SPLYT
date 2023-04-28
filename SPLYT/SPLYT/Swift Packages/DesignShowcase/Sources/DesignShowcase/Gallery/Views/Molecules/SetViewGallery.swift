import SwiftUI
import DesignSystem
import ExerciseCore

struct SetViewGallery: View {
    var body: some View {
        VStack {
            SetView(viewState: SetViewState(setIndex: 0,
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              repsTitle: "reps",
                                                              input: RepsWeightInput(weight: 135)),
                                            modifier: .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 1,
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              repsTitle: "reps",
                                                              input: RepsWeightInput(weight: 225,
                                                                                     reps: 8)),
                                            modifier: .restPause(set: .repsOnly(title: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 2,
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps",
                                                            input: RepsOnlyInput(reps: 8)),
                                            modifier: .eccentric),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 4,
                                            title: "Set 4",
                                            type: .time(title: "sec",
                                                        input: TimeInput(seconds: 30))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 5,
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps",
                                                            input: RepsOnlyInput(placeholder: 8))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 5,
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps")),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
        }
    }
}
