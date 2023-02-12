import SwiftUI
import DesignSystem

struct SetViewGallery: View {
    let action: (AnyHashable, Double) -> Void = { print("ID: \($0), Amount: \($1))") }
    
    var body: some View {
        VStack {
            SetView(viewState: SetViewState(id: "id-1",
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: "135", repsTitle: "reps")),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-2",
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: "135", repsTitle: "reps", repsPlaceholder: "225"),
                                            tag: .dropSet),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-3",
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps", placeholder: "8")),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-4",
                                            title: "Set 4",
                                            type: .time(title: "sec", placeholder: "30"))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-5",
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps"),
                                            tag: .eccentric),
                    updateAction: action)
            SetView(viewState: SetViewState(id: "id-6",
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", placeholder: "12"),
                                            tag: .restPause),
                    updateAction: action)
        }
    }
}
