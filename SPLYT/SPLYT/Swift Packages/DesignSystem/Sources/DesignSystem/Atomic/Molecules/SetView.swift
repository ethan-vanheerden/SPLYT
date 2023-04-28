
import SwiftUI
import ExerciseCore

public struct SetView: View {
    @State private var showBaseActionSheet: Bool = false
    private let viewState: SetViewState
    private let updateSetAction: (Int, SetInput) -> Void // All these Ints represent the set index the action is happening to
    private let addModifierAction: (Int) -> Void
    private let removeModifierAction: (Int) -> Void
    private let updateModifierAction: (Int, SetInput) -> Void
    private let horizontalPadding = Layout.size(4)
    
    public init(viewState: SetViewState,
                updateSetAction: @escaping (Int, SetInput) -> Void,
                addModifierAction: @escaping (Int) -> Void,
                removeModifierAction: @escaping (Int) -> Void,
                updateModifierAction: @escaping (Int, SetInput) -> Void) {
        self.viewState = viewState
        self.updateSetAction = updateSetAction
        self.addModifierAction = addModifierAction
        self.removeModifierAction = removeModifierAction
        self.updateModifierAction = updateModifierAction
    }
    
    public var body: some View {
        VStack {
            ZStack(alignment: .top) { // Use ZStack to keep different type of set views center aligned
                HStack {
                    Text(viewState.title)
                        .subhead(style: .semiBold)
                        .padding(.leading, horizontalPadding)
                        .padding(.trailing, Layout.size(4))
                    Spacer()
                    IconButton(iconName: "ellipsis",
                               style: .secondary) { showBaseActionSheet = true }
                        .padding(.trailing, horizontalPadding)
                }
                entryView(setIndex: viewState.setIndex,
                          setType: viewState.type,
                          updateAction: updateSetAction)
                .offset(y: -Layout.size(0.5)) // Text view automatic padding issues
            }
            modifierView
        }
        .confirmationDialog("", isPresented: $showBaseActionSheet, titleVisibility: .hidden) {
            if let _ = viewState.modifier {
                Button(Strings.removeModifier) { removeModifierAction(viewState.setIndex) }
            } else {
                Button(Strings.addModifier) { addModifierAction(viewState.setIndex) }
            }
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
                         input: .reps(input.reps)) { newReps in
                    let newInput = RepsWeightInput(reps: Int(newReps))
                    updateAction(setIndex, .repsWeight(newInput))
                }
                // Weight entry
                SetEntry(title: weightTitle,
                         input: .weight(input.weight)) { newWeight in
                    let newInput = RepsWeightInput(weight: newWeight)
                    updateAction(setIndex, .repsWeight(newInput))
                }
            }
        case let .repsOnly(title, reps, repsPlaceholder):
            SetEntry(title: title,
                     input: .reps(reps)) { newReps in
                updateAction(setIndex, .repsOnly(reps: Int(newReps)))
            }
        case let .time(title, seconds, secondsPlaceholder):
            SetEntry(title: title,
                     input: .time(seconds)) { newSeconds in
                updateAction(setIndex, .time(seconds: Int(newSeconds)))
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
                        .padding(.top, Layout.size(0.5)) // Text view automatic padding issues
                    Spacer()
                }
                additionalSetView(modifier: modifier)
                    .offset(y: -Layout.size(1)) // Text view automatic padding issues
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
