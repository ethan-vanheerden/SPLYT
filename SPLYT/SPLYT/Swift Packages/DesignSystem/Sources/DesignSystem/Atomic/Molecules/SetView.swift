
import SwiftUI
import ExerciseCore

public struct SetView: View {
    @State private var showBaseActionSheet: Bool = false
    private let viewState: SetViewState
    private let exerciseType: ExerciseViewType
    private let updateSetAction: (Int, SetInput) -> Void // All these Ints represent the set index the action is happening to
    private let updateModifierAction: (Int, SetInput) -> Void
    private let horizontalPadding = Layout.size(4)
    
    public init(viewState: SetViewState,
                exerciseType: ExerciseViewType,
                updateSetAction: @escaping (Int, SetInput) -> Void,
                updateModifierAction: @escaping (Int, SetInput) -> Void) {
        self.viewState = viewState
        self.exerciseType = exerciseType
        self.updateSetAction = updateSetAction
        self.updateModifierAction = updateModifierAction
    }
    
    public var body: some View {
        switch exerciseType {
        case let .build(addModifierAction, removeModifierAction):
            mainView
                .confirmationDialog("", isPresented: $showBaseActionSheet, titleVisibility: .hidden) {
                    if let _ = viewState.modifier {
                        Button(Strings.removeModifier) { removeModifierAction(viewState.setIndex) }
                    } else {
                        Button(Strings.addModifier) { addModifierAction(viewState.setIndex) }
                    }
                }
        case .inProgress:
            mainView
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack {
            ZStack(alignment: .top) { // Use ZStack to keep different type of set views center aligned
                HStack {
                    Text(viewState.title)
                        .subhead(style: .semiBold)
                        .padding(.leading, horizontalPadding)
                        .padding(.trailing, Layout.size(4))
                    Spacer()
                    iconButton
                }
                entryView(setIndex: viewState.setIndex,
                          setType: viewState.type,
                          updateAction: updateSetAction)
                .offset(y: -Layout.size(0.5)) // TextField automatic padding issues
            }
            modifierView
        }
    }
    
    @ViewBuilder private var iconButton: some View {
        switch exerciseType {
        case .build:
            IconButton(iconName: "ellipsis",
                       style: .secondary,
                       iconColor: .lightBlue) { showBaseActionSheet = true }
                .padding(.trailing, horizontalPadding)
        case let .inProgress(usePreviousAction, _):
            IconButton(iconName: "arrow.counterclockwise") {
                usePreviousAction(viewState.setIndex)
            }
            .isVisible(viewState.type.hasPlaceholder)
            .padding(.trailing, horizontalPadding)
        }
    }
    
    @ViewBuilder
    private func entryView(setIndex: Int,
                           setType: SetInputViewState,
                           updateAction: @escaping (Int, SetInput) -> Void) -> some View {
        switch setType {
        case let .repsWeight(weightTitle, repsTitle, input):
            HStack(spacing: Layout.size(4)) {
                // Reps entry
                SetEntry(title: repsTitle,
                         input: .reps(input.reps),
                         placeholder: .reps(input.repsPlaceholder)) { newReps in
                    let newInput = RepsWeightInput(reps: Int(newReps))
                    updateAction(setIndex, .repsWeight(input: newInput))
                }
                // Weight entry
                SetEntry(title: weightTitle,
                         input: .weight(input.weight),
                         placeholder: .weight(input.weightPlaceholder)) { newWeight in
                    let newInput = RepsWeightInput(weight: newWeight)
                    updateAction(setIndex, .repsWeight(input: newInput))
                }
            }
        case let .repsOnly(title, input):
            SetEntry(title: title,
                     input: .reps(input.reps),
                     placeholder: .reps(input.placeholder)) { newReps in
                let newInput = RepsOnlyInput(reps: Int(newReps))
                updateAction(setIndex, .repsOnly(input: newInput))
            }
        case let .time(title, input):
            SetEntry(title: title,
                     input: .time(input.seconds),
                     placeholder: .time(input.placeholder)) { newSeconds in
                let newInput = TimeInput(seconds: Int(newSeconds))
                updateAction(setIndex, .time(input: newInput))
            }
        }
    }
    
    @ViewBuilder
    private var modifierView: some View {
        if let modifier = viewState.modifier {
            ZStack(alignment: .top) {
                HStack {
                    tagView(modifier: modifier)
                        .padding(.leading, horizontalPadding)
                        .padding(.top, Layout.size(0.5)) // TextField automatic padding issues
                    Spacer()
                }
                additionalSetView(modifier: modifier)
                    .offset(y: -Layout.size(1)) // TextField automatic padding issues
            }
        } else {
            EmptyView()
        }
    }
    
    private func tagView(modifier: SetModifierViewState) -> some View {
        var offset: CGFloat = 0 // If a tag has no associated SetInput, we can move it up
        
        switch modifier {
        case .eccentric:
            offset = -Layout.size(6)
        default:
            break
        }
        
        let viewState = TagFactory.tagFromModifier(modifier: modifier)
        
        return Tag(viewState: viewState)
            .offset(y: offset)
    }
    
    @ViewBuilder
    private func additionalSetView(modifier: SetModifierViewState) -> some View {
        switch modifier {
        case .dropSet(let set),
                .restPause(let set):
            entryView(setIndex: viewState.setIndex,
                      setType: set,
                      updateAction: updateModifierAction)
        case .eccentric:
            EmptyView()
        }
    }
}

// MARK: - View State

public struct SetViewState: Equatable {
    public let setIndex: Int // The set's index in an exercise
    let title: String
    let type: SetInputViewState
    let modifier: SetModifierViewState?
    
    public init(setIndex: Int,
                title: String,
                type: SetInputViewState,
                modifier: SetModifierViewState? = nil) {
        self.setIndex = setIndex
        self.title = title
        self.type = type
        self.modifier = modifier
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addModifier = "Add Modifier"
    static let removeModifier = "Remove Modifier"
}
