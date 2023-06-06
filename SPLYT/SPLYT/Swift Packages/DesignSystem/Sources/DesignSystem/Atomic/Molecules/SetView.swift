
import SwiftUI
import ExerciseCore
import Core

public struct SetView: View {
    @State private var showBaseActionSheet: Bool = false
    private let viewState: SetViewState
    private let exerciseType: ExerciseViewType
    // Set index, the updated input, whether or not we should overwrite with nil values
    private let updateSetAction: (Int, SetInput) -> Void
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
                    iconButton(forModifier: false)
                }
                entryView(setInput: viewState.input,
                          updateAction: updateSetAction)
                .offset(y: -Layout.size(0.5)) // TextField automatic padding issues
            }
            modifierView
        }
    }
    
    @ViewBuilder
    private func entryView(setInput: SetInputViewState,
                           updateAction: @escaping (Int, SetInput) -> Void) -> some View {
        switch setInput {
        case let .repsWeight(weightTitle, repsTitle, input):
            HStack(spacing: Layout.size(4)) {
                // Reps Entry
                let repsBinding = entryBinding(value: String(input.reps),
                                               input: setInput,
                                               repsInRepsWeight: true,
                                               updateAction: updateAction)
                SetEntry(input: repsBinding,
                         title: repsTitle,
                         keyboardType: .reps,
                         placeholder: String(input.repsPlaceholder))
                
                // Weight Entry
                let weightBinding = entryBinding(value: String(input.weight),
                                                 input: setInput,
                                                 updateAction: updateAction)
                SetEntry(input: weightBinding,
                         title: weightTitle,
                         keyboardType: .weight,
                         placeholder: String(input.weightPlaceholder))
            }
        case let .repsOnly(title, input):
            let repsBinding = entryBinding(value: String(input.reps),
                                           input: setInput,
                                           updateAction: updateAction)
            SetEntry(input: repsBinding,
                     title: title,
                     keyboardType: .reps,
                     placeholder: String(input.placeholder))
        case let .time(title, input):
            let secondsBinding = entryBinding(value: String(input.seconds),
                                              input: setInput,
                                              updateAction: updateAction)
            SetEntry(input: secondsBinding,
                     title: title,
                     keyboardType: .time,
                     placeholder: String(input.placeholder))
        }
    }
    
    @ViewBuilder
    private func iconButton(forModifier: Bool) -> some View {
        switch exerciseType {
        case .build where forModifier == false:
            IconButton(iconName: "ellipsis",
                       style: .secondary,
                       iconColor: .lightBlue) { showBaseActionSheet = true }
                .padding(.trailing, horizontalPadding)
        case let .inProgress(usePreviousInputAction, _):
            IconButton(iconName: "arrow.counterclockwise") {
                usePreviousInputAction(viewState.setIndex, forModifier)
            }
            .isVisible(usePreviousIconVisible(forModifier: forModifier))
            .padding(.trailing, horizontalPadding)
        default:
            EmptyView()
        }
    }
    
    /// Determines if the button to use previous input on a set row is visible.
    /// This should only be visible if there is a placeholder without actual input already there.
    /// - Parameter forModifier: Whether the set row is for a modifier or not.
    /// - Returns: True if the icon should be visible, false otherwise
    private func usePreviousIconVisible(forModifier: Bool) -> Bool {
        let isVisible: Bool
        if forModifier {
            isVisible = viewState.modifier?.hasPlaceholder ?? false && !(viewState.modifier?.hasValue ?? true)
        } else {
            isVisible = viewState.input.hasPlaceholder && !viewState.input.hasInput
        }
        return isVisible
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
                    iconButton(forModifier: true)
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
            entryView(setInput: set,
                      updateAction: updateModifierAction)
        case .eccentric:
            EmptyView()
        }
    }
    
    
    /// Creates a binding to the textfield used for a set entry.
    /// - Parameters:
    ///   - value: The value to be present in the text field
    ///   - input: The type of set input that this text field will represent
    ///   - repsInRepsWeight: If this is a reps and weight set, indicates if this is for the rep text field
    ///   - updateAction: The update action to perform when the text value in the text field changes
    /// - Returns: A binding to use for getting/updating values for the set text fields.
    private func entryBinding(value: String,
                              input: SetInputViewState,
                              repsInRepsWeight: Bool = false,
                              updateAction: @escaping (Int, SetInput) -> Void) -> Binding<String> {
        return Binding(
            get: { return value },
            set: { newValue in
                // Note: with this logic, if an input is not valid, we set the input to an empty
                let parsedInput = validateText(input: newValue)
                let newInput: SetInput
                
                switch input {
                case .repsWeight(_, _, var input):
                    if repsInRepsWeight {
                        input.reps = Int(parsedInput)
                    } else {
                        input.weight = parsedInput
                    }
                    newInput = .repsWeight(input: input)
                case .repsOnly(_, var input):
                    input.reps = Int(parsedInput)
                    newInput = .repsOnly(input: input)
                case .time(_, var input):
                    input.seconds = Int(parsedInput)
                    newInput = .time(input: input)
                }
                updateAction(viewState.setIndex, newInput)
            }
        )
    }
    
    private func validateText(input: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: input)?.doubleValue
    }
}

// MARK: - View State

public struct SetViewState: Equatable, Hashable {
    public let setIndex: Int // The set's index in an exercise
    let title: String
    let input: SetInputViewState
    let modifier: SetModifierViewState?
    
    public init(setIndex: Int,
                title: String,
                type: SetInputViewState,
                modifier: SetModifierViewState? = nil) {
        self.setIndex = setIndex
        self.title = title
        self.input = type
        self.modifier = modifier
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let addModifier = "Add Modifier"
    static let removeModifier = "Remove Modifier"
}
