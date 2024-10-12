import SwiftUI
import ExerciseCore

public struct ExerciseView: View {
    @State private var showActionSheet: Bool = false
    @EnvironmentObject private var userTheme: UserTheme
    private let arguments: ExerciseViewArguments
    private let horizontalPadding = Layout.size(2)
    
    public init(arguments: ExerciseViewArguments) {
        self.arguments = arguments
    }
    
    public var body: some View {
        switch arguments {
        case let .regular(viewState, type, addSetAction, removeSetAction, 
                          updateSetAction, updateModifierAction, addModifierAction, removeModifierAction):
            loadedView(viewState: viewState,
                       type: type,
                       addSetAction: addSetAction,
                       removeSetAction: removeSetAction,
                       updateSetAction: updateSetAction,
                       updateModifierAction: updateModifierAction,
                       addModifierAction: addModifierAction,
                       removeModifierAction: removeModifierAction)
        case .loading:
            ProgressView()
                .padding(.vertical, Layout.size(2))
        }
    }
    
    @ViewBuilder
    private func loadedView(viewState: ExerciseViewState,
                            type: ExerciseViewType,
                            addSetAction: @escaping () -> Void,
                            removeSetAction: @escaping () -> Void,
                            updateSetAction: @escaping (Int, SetInput) -> Void,
                            updateModifierAction: @escaping (Int, SetInput) -> Void,
                            addModifierAction: @escaping (Int) -> Void,
                            removeModifierAction: @escaping (Int) -> Void) -> some View {
        VStack {
            header(viewState: viewState, type: type)
            ForEach(viewState.sets, id: \.setIndex) { set in
                SetView(viewState: set,
                        exerciseType: type,
                        updateSetAction: updateSetAction,
                        updateModifierAction: updateModifierAction,
                        addModifierAction: addModifierAction,
                        removeModifierAction: removeModifierAction)
            }
            .padding(.horizontal, horizontalPadding)
            setButtons(viewState: viewState,
                       type: type,
                       addSetAction: addSetAction,
                       removeSetAction: removeSetAction)
        }
        .themedConfirmationDialog(isPresented: $showActionSheet) {
            switch type {
            case .build:
                EmptyView()
            case let .inProgress(_, _, replaceExerciseAction, deleteExerciseAction, canDeleteExercise):
                Button(Strings.replaceExercise) { replaceExerciseAction() }
                if canDeleteExercise {
                    Button(Strings.deleteExercise, role: .destructive) { deleteExerciseAction() }
                }
            }
        }
    }
    
    @ViewBuilder
    private func header(viewState: ExerciseViewState, type: ExerciseViewType) -> some View {
        HStack {
            SectionHeader(viewState: viewState.header)
            Spacer()
            switch type {
            case .build:
                EmptyView()
            case .inProgress:
                IconButton(iconName: "square.and.pencil",
                           style: .secondary,
                           iconColor: userTheme.theme) {
                    showActionSheet = true
                }
                           .padding(.trailing, horizontalPadding)
            }
        }
    }
    
    @ViewBuilder
    private func setButtons(viewState: ExerciseViewState,
                            type: ExerciseViewType,
                            addSetAction: @escaping () -> Void,
                            removeSetAction: @escaping () -> Void) -> some View {
        HStack(spacing: Layout.size(2)) {
            addRemoveSetButtons(viewState: viewState, 
                                addSetAction: addSetAction,
                                removeSetAction: removeSetAction)
            Spacer()
            switch type {
            case .build:
                EmptyView()
            case let .inProgress(_, addNoteAction, _, _, _):
                SplytButton(text: Strings.addNote,
                            action: addNoteAction)
                .frame(width: Layout.size(20))
                .isVisible(false) // TODO: 51: Workout notes
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    @ViewBuilder
    private func addRemoveSetButtons(viewState: ExerciseViewState,
                                     addSetAction: @escaping () -> Void,
                                     removeSetAction: @escaping () -> Void) -> some View {
        IconButton(iconName: "minus",
                   iconColor: .white,
                   isEnabled: viewState.canRemoveSet) { removeSetAction() }
        IconButton(iconName: "plus",
                   iconColor: .white) { addSetAction() }
    }
}

// MARK: - Type

public enum ExerciseViewType {
    case build
    case inProgress(usePreviousInputAction: (Int, Bool) -> Void, // (Set index, For Modifier)
                    addNoteAction: () -> Void,
                    replaceExerciseAction: () -> Void,
                    deleteExerciseAction: () -> Void,
                    canDeleteExercise: Bool)
}

// MARK: - Arguments

public enum ExerciseViewArguments {
    case regular(
        viewState: ExerciseViewState,
        type: ExerciseViewType,
        addSetAction: () -> Void,
        removeSetAction: () -> Void,
        updateSetAction: (Int, SetInput) -> Void, // Set index, input
        updateModifierAction: (Int, SetInput) -> Void, // Set index, input
        addModifierAction: (Int) -> Void, // Set index
        removeModifierAction: (Int) -> Void // Set index
    )
    case loading
}

// MARK: - Status

public enum ExerciseViewStatus: Equatable, Hashable {
    case loaded(ExerciseViewState)
    case loading
}

// MARK: - View State

public struct ExerciseViewState: Equatable, Hashable {
    public let header: SectionHeaderViewState
    public let sets: [SetViewState]
    let canRemoveSet: Bool
    public let numSetsTitle: String
    
    public init(header: SectionHeaderViewState,
                sets: [SetViewState],
                canRemoveSet: Bool,
                numSetsTitle: String) {
        self.header = header
        self.sets = sets
        self.canRemoveSet = canRemoveSet
        self.numSetsTitle = numSetsTitle
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addNote = "Add note"
    static let replaceExercise = "Replace Exercise"
    static let deleteExercise = "Delete Exercise"
}
