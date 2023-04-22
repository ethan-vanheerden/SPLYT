import SwiftUI
import DesignSystem
import ExerciseCore

struct SetViewGallery: View {
    var body: some View {
        VStack {
            SetView(viewState: SetViewState(setIndex: 0,
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps"),
                                            modifier: .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 1,
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps",
                                                              reps: 225),
                                            modifier: .restPause(set: .repsOnly(title: "reps"))),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 2,
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps", reps: 8),
                                            modifier: .eccentric),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 4,
                                            title: "Set 4",
                                            type: .time(title: "sec", seconds: 30)),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 5,
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps")),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
            SetView(viewState: SetViewState(setIndex: 5,
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", reps: 12)),
                    updateSetAction: { _, _ in },
                    addModifierAction: { _ in },
                    removeModifierAction: { _ in },
                    updateModifierAction: { _, _ in })
        }
    }
}
