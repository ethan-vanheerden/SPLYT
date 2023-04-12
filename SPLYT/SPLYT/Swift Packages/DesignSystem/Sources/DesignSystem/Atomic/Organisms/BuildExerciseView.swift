
import SwiftUI
import ExerciseCore

public struct BuildExerciseView: View {
    private let viewState: BuildExerciseViewState
    private let addSetAction: () -> Void
    private let removeSetAction: () -> Void
    private let addModifierAction: (AnyHashable) -> Void
    private let removeModifierAction: (AnyHashable) -> Void
    private let updateAction: (AnyHashable, SetInput) -> Void
    
    public init(viewState: BuildExerciseViewState,
                addSetAction: @escaping () -> Void,
                removeSetAction: @escaping () -> Void,
                addModifierAction: @escaping (AnyHashable) -> Void,
                removeModifierAction: @escaping (AnyHashable) -> Void,
                updateAction: @escaping (AnyHashable, SetInput) -> Void) {
        self.viewState = viewState
        self.addSetAction = addSetAction
        self.removeSetAction = removeSetAction
        self.addModifierAction = addModifierAction
        self.removeModifierAction = removeModifierAction
        self.updateAction = updateAction
    }
    
    public var body: some View {
        VStack {
            SectionHeader(viewState: viewState.header)
                .padding(.horizontal, Layout.size(2))
            ForEach(viewState.sets, id: \.id) { set in
                SetView(viewState: set,
                        updateAction: updateAction,
                        addModifierAction: addModifierAction,
                        removeModifierAction: removeModifierAction)
            }
            setButtons
        }
    }
    
    @ViewBuilder
    private var setButtons: some View {
        HStack(spacing: Layout.size(2)) {
            IconButton(iconName: "minus",
                       style: .primary(backgroundColor: .lightBlue),
                       iconColor: .white,
                       isEnabled: viewState.canRemoveSet) { removeSetAction() }
            IconButton(iconName: "plus",
                       style: .primary(backgroundColor: .lightBlue),
                       iconColor: .white) { addSetAction() }
            
            Spacer()
        }
        .padding(.leading, Layout.size(4))
    }
}

// MARK: View State

public struct BuildExerciseViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let header: SectionHeaderViewState
    let sets: [SetViewState]
    let canRemoveSet: Bool
    
    public init(id: AnyHashable,
                header: SectionHeaderViewState,
                sets: [SetViewState],
                canRemoveSet: Bool) {
        self.id = id
        self.header = header
        self.sets = sets
        self.canRemoveSet = canRemoveSet
    }
}
