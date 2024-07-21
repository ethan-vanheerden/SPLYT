import SwiftUI
import ExerciseCore
import Core

public struct SetView: View {
    @State private var showBaseActionSheet: Bool = false
    @EnvironmentObject private var userTheme: UserTheme
    private let viewState: SetViewState
    private let exerciseType: ExerciseViewType
    private let updateSetAction: (Int, SetInput) -> Void // Set index, the new input
    private let updateModifierAction: (Int, SetInput) -> Void
    private let addModifierAction: (Int) -> Void
    private let removeModifierAction: (Int) -> Void
    private let iconButtonOffset = Layout.size(1)
    
    public init(viewState: SetViewState,
                exerciseType: ExerciseViewType,
                updateSetAction: @escaping (Int, SetInput) -> Void,
                updateModifierAction: @escaping (Int, SetInput) -> Void,
                addModifierAction: @escaping (Int) -> Void,
                removeModifierAction: @escaping (Int) -> Void) {
        self.viewState = viewState
        self.exerciseType = exerciseType
        self.updateSetAction = updateSetAction
        self.updateModifierAction = updateModifierAction
        self.addModifierAction = addModifierAction
        self.removeModifierAction = removeModifierAction
    }
    
    public var body: some View {
        mainView
            .confirmationDialog("", isPresented: $showBaseActionSheet, titleVisibility: .hidden) {
                let forModifier = viewState.modifier != nil
                if case let .inProgress(usePreviousInputAction, _, _, _, _) = exerciseType,
                hasPreviousInput(forModifier: forModifier) {
                    Button(Strings.usePreviousInput) {
                        usePreviousInputAction(viewState.setIndex, forModifier)
                    }
                }
                if let _ = viewState.modifier {
                    Button(Strings.removeModifier) { removeModifierAction(viewState.setIndex) }
                } else {
                    Button(Strings.addModifier) { addModifierAction(viewState.setIndex) }
                }
            }
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack(alignment: .leading) {
            setRow(modifier: nil)
            if let modifier = viewState.modifier {
                setRow(modifier: modifier)
            }
        }
    }
    
    @ViewBuilder
    private func setRow(modifier: SetModifierViewState?) -> some View {
        HStack {
            rowTitle(modifier: modifier)
                .alignmentGuide(VerticalAlignment.center) { d in
                    d[.bottom]
                }
                .frame(width: Layout.size(6), alignment: .leading) // Fixed width for consistent text field placement
            Spacer()
            if let modifier = modifier {
                modifierView(modifier: modifier)
            } else {
                entryView(setInput: viewState.input, updateAction: updateSetAction)
            }
            Spacer()
            iconButton
                .alignmentGuide(VerticalAlignment.center) { d in
                    d[.bottom] - iconButtonOffset
                }
                .isVisible(modifier == nil) // For consistent spacing
        }
    }
    
    @ViewBuilder
    private func rowTitle(modifier: SetModifierViewState?) -> some View {
        if let modifier = modifier {
            tagView(modifier: modifier)
        } else {
            HStack {
                Text(viewState.title)
                    .subhead(style: .semiBold)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func entryView(setInput: SetInputViewState,
                           updateAction: @escaping (Int, SetInput) -> Void) -> some View {
        switch setInput {
        case let .repsWeight(weightTitle, repsTitle, input):
            HStack(spacing: Layout.size(4)) {
                // Reps Entry
                SetEntry(input: entryBinding(input: String(input.reps),
                                          setInput: setInput,
                                          keyboardType: .reps,
                                          updateAction: setUpdateAction(input: setInput,
                                                                        repsInRepsWeight: true,
                                                                        updateAction: updateAction)),
                         title: repsTitle,
                         keyboardType: .reps,
                         placeholder: String(input.repsPlaceholder))
                
                // Weight Entry
                SetEntry(input: entryBinding(input: String(input.weight),
                                          setInput: setInput,
                                          keyboardType: .weight,
                                          updateAction: setUpdateAction(input: setInput,
                                                                        updateAction: updateAction)),
                         title: weightTitle,
                         keyboardType: .weight,
                         placeholder: String(input.weightPlaceholder))
            }
        case let .repsOnly(title, input):
            SetEntry(input: entryBinding(input: String(input.reps),
                                      setInput: setInput,
                                      keyboardType: .reps,
                                      updateAction: setUpdateAction(input: setInput,
                                                                    updateAction: updateAction)),
                     title: title,
                     keyboardType: .reps,
                     placeholder: String(input.placeholder))
        case let .time(title, input):
            SetEntry(input: entryBinding(input: String(input.seconds),
                                      setInput: setInput,
                                      keyboardType: .time,
                                      updateAction: setUpdateAction(input: setInput,
                                                                    updateAction: updateAction)),
                     title: title,
                     keyboardType: .time,
                     placeholder: String(input.placeholder))
        }
    }
    
    private func entryBinding(input: String, 
                              setInput: SetInputViewState,
                              keyboardType: KeyboardInputType,
                              updateAction: @escaping (String) -> Void) -> Binding<String> {
        return Binding(
            get: { input },
            set: { newValue in
                guard !newValue.hasSuffix(".") else { return }
                
                let validText = SetEntryFormatter.validateText(text: newValue, inputType: keyboardType)
                updateAction(validText)
            }
        )
    }
    
    @ViewBuilder
    private var iconButton: some View {
        IconButton(iconName: "ellipsis",
                   style: .secondary,
                   iconColor: userTheme.theme) { showBaseActionSheet = true }
    }
    
    /// Determines if the button to use previous input in the confirmation dialog is visible.
    /// This should only be visible if there is a placeholder without actual input already there.
    /// - Parameter forModifier: Whether the set row is for a modifier or not.
    /// - Returns: True if the icon should be visible, false otherwise
    private func hasPreviousInput(forModifier: Bool) -> Bool {
        let isVisible: Bool
        if forModifier {
            isVisible = viewState.modifier?.hasPlaceholder ?? false && !(viewState.modifier?.hasValue ?? true)
        } else {
            isVisible = viewState.input.hasPlaceholder && !viewState.input.hasInput
        }
        return isVisible
    }
    
    private func tagView(modifier: SetModifierViewState) -> some View {
        // If a tag has no associated SetInput, we can move it up
        let offset: CGFloat = modifier.hasAdditionalInput ? 0 : -Layout.size(3)
        let viewState = TagFactory.tagFromModifier(modifier: modifier,
                                                   color: userTheme.theme)
        
        return Tag(viewState: viewState)
            .fixedSize()
            .offset(y: offset)
    }
    
    @ViewBuilder
    private func modifierView(modifier: SetModifierViewState) -> some View {
        switch modifier {
        case .dropSet(let set),
                .restPause(let set):
            entryView(setInput: set,
                      updateAction: updateModifierAction)
        case .eccentric:
            EmptyView()
        }
    }
    
    private func setUpdateAction(input: SetInputViewState,
                                 repsInRepsWeight: Bool = false,
                                 updateAction: @escaping (Int, SetInput) -> Void) -> ((String) -> Void) {
        return { validText in
            let parsedInput = Double(validText)
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
    static let usePreviousInput = "Use Previous Input"
}
