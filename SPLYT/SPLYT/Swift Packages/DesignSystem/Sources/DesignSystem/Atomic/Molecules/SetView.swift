
import SwiftUI
import ExerciseCore

public struct SetView: View {
    @State private var showBaseActionSheet: Bool = false
    private let viewState: SetViewState
    // AnyHashable to represent the setId, SetInput to represent the new value
    private let updateAction: (AnyHashable, SetInput) -> Void
    private let addModifierAction: (AnyHashable) -> Void // AnyHashable to represent the set we are adding the modifier to
    private let removeModifierAction: (AnyHashable) -> Void // AnyHashable to represent the set we are removing the modifier from
    private let horizontalPadding = Layout.size(4)
    
    public init(viewState: SetViewState,
                updateAction: @escaping (AnyHashable, SetInput) -> Void,
                addModifierAction: @escaping (AnyHashable) -> Void,
                removeModifierAction: @escaping (AnyHashable) -> Void) {
        self.viewState = viewState
        self.updateAction = updateAction
        self.addModifierAction = addModifierAction
        self.removeModifierAction = removeModifierAction
    }
    
    public var body: some View {
        //        ZStack {
        //            entries
        //            HStack {
        //                Spacer()
        //                IconButton(iconName: "ellipsis",
        //                           style: .secondary) { showBaseActionSheet = true }
        //                    .padding(.trailing, horizontalPadding)
        //            }
        //            HStack {
        //                Text(viewState.title)
        //                    .subhead(style: .semiBold)
        //                    .padding(.bottom, Layout.size(2))
        //                    .padding(.leading, horizontalPadding)
        //                Spacer()
        //            }
        //        }
        //        .confirmationDialog("", isPresented: $showBaseActionSheet, titleVisibility: .hidden) {
        //            if let _ = viewState.modifier {
        //                Button(Strings.removeModifier) { removeModifierAction(viewState.id) }
        //            } else {
        //                Button(Strings.addModifier) { addModifierAction(viewState.id) }
        //            }
        //
        //        }
        
        
        VStack {
            ZStack(alignment: .top) {
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
                entryView(id: viewState.id, setType: viewState.type)
                    .offset(y: -Layout.size(0.5)) // Text view automatic padding issues
            }
            modifierView
        }
        .confirmationDialog("", isPresented: $showBaseActionSheet, titleVisibility: .hidden) {
            if let _ = viewState.modifier {
                Button(Strings.removeModifier) { removeModifierAction(viewState.id) }
            } else {
                Button(Strings.addModifier) { addModifierAction(viewState.id) }
            }
        }
    }
    
    @ViewBuilder
    private var entries: some View {
        VStack {
            entryView(id: viewState.id, setType: viewState.type)
            modifierView
        }
    }
    
    @ViewBuilder
    private func entryView(id: AnyHashable, setType: SetInputViewState) -> some View {
        switch setType {
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
        let color: SplytColor
        let type = modifier.type
        
        switch type {
        case .dropSet:
            color = .green
        case .restPause:
            color = .gray
        case .eccentric:
            color = .red
        }
        
        return Tag(viewState: TagViewState(title: type.title, color: color))
    }
    
    @ViewBuilder
    private func additionalSetView(modifier: SetModifierViewState) -> some View {
        switch modifier.type {
        case .dropSet(let set),
                .restPause(let set):
            entryView(id: modifier.id, setType: set)
        case .eccentric:
            EmptyView()
        }
    }
}

// MARK: - View State

public struct SetViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let title: String
    let type: SetInputViewState
    let modifier: SetModifierViewState?
    
    public init(id: AnyHashable,
                title: String,
                type: SetInputViewState,
                modifier: SetModifierViewState? = nil) {
        self.id = id
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
