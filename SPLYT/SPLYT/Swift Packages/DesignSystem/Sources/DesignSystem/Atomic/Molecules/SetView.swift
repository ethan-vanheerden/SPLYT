
import SwiftUI
import ExerciseCore

public struct SetView: View {
    private let viewState: SetViewState
    // AnyHashable to represent the setId, SetInput to represent the new value
    private let updateAction: (AnyHashable, SetInput) -> Void
    private let horizontalPadding = Layout.size(4)

    public init(viewState: SetViewState,
                updateAction: @escaping (AnyHashable, SetInput) -> Void) {
        self.viewState = viewState
        self.updateAction = updateAction
    }

    public var body: some View {
        ZStack {
            entries
            HStack {
                Spacer()
                tagView
                    .padding(.trailing, horizontalPadding)
            }
            HStack {
                Text(viewState.title)
                    .subhead(style: .semiBold)
                    .padding(.bottom, Layout.size(2))
                    .padding(.leading, horizontalPadding)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var entries: some View {
        switch viewState.type {
        case let .repsWeight(weightTitle, weightPlaceholder, repsTitle, repsPlaceholder):
            HStack(spacing: Layout.size(4)) {
                // Reps entry
                SetEntry(title: repsTitle,
                         inputType: .reps(repsPlaceholder)) { newReps in
                    updateAction(viewState.id, .repsWeight(reps: Int(newReps), weight: nil))
                }
                // Weight entry
                SetEntry(title: weightTitle,
                         startingInput: <#T##String?#>
                         inputType: .weight(weightPlaceholder)) { newWeight in
                    updateAction(viewState.id, .repsWeight(reps: nil, weight: newWeight))
                }
            }
        case let .repsOnly(title, placeholder):
            SetEntry(title: title,
                     inputType: .reps(placeholder)) { newReps in
                updateAction(viewState.id, .repsOnly(reps: Int(newReps)))
            }
        case let .time(title, placeholder):
            SetEntry(title: title,
                     inputType: .reps(placeholder)) { newSeconds in
                updateAction(viewState.id, .time(seconds: Int(newSeconds)))
            }
        }
    }
    
    @ViewBuilder
    private var tagView: some View {
        if let tag = viewState.tag {
            tag.tag
                .padding(.bottom, Layout.size(2))
        } else {
            EmptyView()
        }
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SetView(viewState: SetViewState(id: "id-1",
                                            title: "Set 1",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: 135, repsTitle: "reps"))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-2",
                                            title: "Set 2",
                                            type: .repsWeight(weightTitle: "lbs", weightPlaceholder: 135, repsTitle: "reps", repsPlaceholder: 225),
                                            tag: .dropSet)) { _, _ in }
            SetView(viewState: SetViewState(id: "id-3",
                                            title: "Set 3",
                                            type: .repsOnly(title: "reps", placeholder: 8))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-4",
                                            title: "Set 4",
                                            type: .time(title: "sec", placeholder: 30))) { _, _ in }
            SetView(viewState: SetViewState(id: "id-5",
                                            title: "Set 5",
                                            type: .repsOnly(title: "reps"),
                                            tag: .eccentric)) { _, _ in }
            SetView(viewState: SetViewState(id: "id-6",
                                            title: "Set 6",
                                            type: .repsOnly(title: "reps", placeholder: 12),
                                            tag: .restPause)) { _, _ in }
        }
    }
}

// MARK: - View State

public struct SetViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let title: String
    let startingInput: String?
    let type: SetViewType
    let tag: SetTag?

    public init(id: AnyHashable,
                title: String,
                startingInput: String? = nil,
                type: SetViewType,
                tag: SetTag? = nil) {
        self.id = id
        self.title = title
        self.startingInput = startingInput
        self.type = type
        self.tag = tag
    }
}
