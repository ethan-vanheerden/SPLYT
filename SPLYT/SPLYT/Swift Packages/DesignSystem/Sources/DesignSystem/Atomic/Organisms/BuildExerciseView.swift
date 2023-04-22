
import SwiftUI
import ExerciseCore

public struct BuildExerciseView: View {
    private let viewState: BuildExerciseViewState
    private let addSetAction: () -> Void
    private let removeSetAction: () -> Void
    private let addModifierAction: (Int) -> Void // All these Ints represent the set index the action is happening to
    private let removeModifierAction: (Int) -> Void
    private let updateSetAction: (Int, SetInput) -> Void
    private let updateModifierAction: (Int, SetInput) -> Void
    
    public init(viewState: BuildExerciseViewState,
                addSetAction: @escaping () -> Void,
                removeSetAction: @escaping () -> Void,
                addModifierAction: @escaping (Int) -> Void,
                removeModifierAction: @escaping (Int) -> Void,
                updateSetAction: @escaping (Int, SetInput) -> Void,
                updateModifierAction: @escaping (Int, SetInput) -> Void) {
        self.viewState = viewState
        self.addSetAction = addSetAction
        self.removeSetAction = removeSetAction
        self.addModifierAction = addModifierAction
        self.removeModifierAction = removeModifierAction
        self.updateSetAction = updateSetAction
        self.updateModifierAction = updateModifierAction
    }
    
    public var body: some View {
        VStack {
            SectionHeader(viewState: viewState.header)
                .padding(.horizontal, Layout.size(2))
            ForEach(viewState.sets, id: \.setIndex) { set in
                SetView(viewState: set,
                        updateSetAction: updateSetAction,
                        addModifierAction: addModifierAction,
                        removeModifierAction: removeModifierAction,
                        updateModifierAction: updateModifierAction)
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

public struct BuildExerciseViewState: Equatable {
    let header: SectionHeaderViewState
    let sets: [SetViewState]
    let canRemoveSet: Bool
    
    public init(header: SectionHeaderViewState,
                sets: [SetViewState],
                canRemoveSet: Bool) {
        self.header = header
        self.sets = sets
        self.canRemoveSet = canRemoveSet
    }
}
