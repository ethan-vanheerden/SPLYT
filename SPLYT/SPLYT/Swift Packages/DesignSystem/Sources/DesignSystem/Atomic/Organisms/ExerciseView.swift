import SwiftUI
import ExerciseCore

public struct ExerciseView: View {
    private let viewState: ExerciseViewState
    private let type: ExerciseViewType
    private let addSetAction: () -> Void
    private let removeSetAction: () -> Void
    private let updateSetAction: (Int, SetInput) -> Void // Int to represent the set index the action is happening to
    private let updateModifierAction: (Int, SetInput) -> Void
    
    public init(viewState: ExerciseViewState,
                type: ExerciseViewType,
                addSetAction: @escaping () -> Void,
                removeSetAction: @escaping () -> Void,
                updateSetAction: @escaping (Int, SetInput) -> Void,
                updateModifierAction: @escaping (Int, SetInput) -> Void) {
        self.viewState = viewState
        self.type = type
        self.addSetAction = addSetAction
        self.removeSetAction = removeSetAction
        self.updateSetAction = updateSetAction
        self.updateModifierAction = updateModifierAction
    }
    
    public var body: some View {
        VStack {
            SectionHeader(viewState: viewState.header)
                
            ForEach(viewState.sets, id: \.setIndex) { set in
                SetView(viewState: set,
                        exerciseType: type,
                        updateSetAction: updateSetAction,
                        updateModifierAction: updateModifierAction)
            }
            .padding(.horizontal, Layout.size(2))
            setButtons
        }
    }
    
    @ViewBuilder
    private var setButtons: some View {
        HStack(spacing: Layout.size(2)) {
            addRemoveSetButtons
            Spacer()
            switch type {
            case .build:
                EmptyView()
            case let .inProgress(_, addNoteAction):
                SplytButton(text: Strings.addNote,
                            action: addNoteAction)
                .frame(width: Layout.size(20))
            }
        }
        .padding(.leading, Layout.size(4))
        .padding(.trailing, Layout.size(2))
    }
    
    @ViewBuilder
    private var addRemoveSetButtons: some View {
        IconButton(iconName: "minus",
                   style: .primary(backgroundColor: .lightBlue),
                   iconColor: .white,
                   isEnabled: viewState.canRemoveSet) { removeSetAction() }
        IconButton(iconName: "plus",
                   style: .primary(backgroundColor: .lightBlue),
                   iconColor: .white) { addSetAction() }
    }
}

// MARK: - Type

public enum ExerciseViewType {
    // Ints for the set index
    case build(addModifierAction: (Int) -> Void, removeModifierAction: (Int) -> Void)
    // Int for set index, Bool for whether it's for a modifier or not
    case inProgress(usePreviousInputAction: (Int, Bool) -> Void, addNoteAction: () -> Void)
}

// MARK: View State

public struct ExerciseViewState: Equatable, Hashable {
    public let header: SectionHeaderViewState
    public let sets: [SetViewState]
    let canRemoveSet: Bool
    
    public init(header: SectionHeaderViewState,
                sets: [SetViewState],
                canRemoveSet: Bool) {
        self.header = header
        self.sets = sets
        self.canRemoveSet = canRemoveSet
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addNote = "Add note"
}
