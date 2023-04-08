import SwiftUI
import DesignSystem
import ExerciseCore

struct SetViewGallery: View {
    let action: (AnyHashable, SetInput) -> Void = { print("ID: \($0), Input: \($1))") }
    
    var body: some View {
        VStack {
            SetView(viewState: SetViewState(id: "id-1",
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps")),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-2",
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs",
                                                              weight: 135,
                                                              repsTitle: "reps",
                                                              reps: 225),
                                            tag: .dropSet),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-3",
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps", reps: 8)),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-4",
                                            title: "Set 4",
                                            type: .time(title: "sec", seconds: 30))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-5",
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps"),
                                            tag: .eccentric),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-6",
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", reps: 12),
                                            tag: .restPause),
                    updateAction: action)
        }
    }
}
