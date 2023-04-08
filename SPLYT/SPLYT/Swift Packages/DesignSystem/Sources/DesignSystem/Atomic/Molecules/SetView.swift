
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
        case let .repsWeight(weightTitle, weight, repsTitle, reps):
            HStack(spacing: Layout.size(4)) {
                // Reps entry
                SetEntry(title: repsTitle,
                         input: .reps(reps)) { newReps in
                    updateAction(viewState.id, .repsWeight(reps: Int(newReps), weight: nil))
                }
                // Weight entry
                SetEntry(title: weightTitle,
                         input: .weight(weight)) { newWeight in
                    updateAction(viewState.id, .repsWeight(reps: nil, weight: newWeight))
                }
            }
        case let .repsOnly(title, reps):
            SetEntry(title: title,
                     input: .reps(reps)) { newReps in
                updateAction(viewState.id, .repsOnly(reps: Int(newReps)))
            }
        case let .time(title, seconds):
            SetEntry(title: title,
                     input: .time(seconds)) { newSeconds in
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

// MARK: - View State

public struct SetViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let title: String
    let type: SetViewType
    let tag: SetTag?

    public init(id: AnyHashable,
                title: String,
                type: SetViewType,
                tag: SetTag? = nil) {
        self.id = id
        self.title = title
        self.type = type
        self.tag = tag
    }
}
