import SwiftUI
import ExerciseCore

public struct CompletedSetView: View {
    private let viewState: CompletedSetViewState
    @EnvironmentObject private var userTheme: UserTheme
    
    public init(viewState: CompletedSetViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            setRow(modifier: nil)
            if let modifier = viewState.modifier {
                setRow(modifier: modifier)
            }
        }
    }
    
    @ViewBuilder
    private func setRow(modifier: SetModifierViewState?) -> some View {
        HStack(alignment: .top) {
            rowTitle(modifier: modifier)
                .frame(width: Layout.size(12))
            Spacer()
            Group {
                if let modifier = modifier {
                    modifierView(modifier: modifier)
                } else {
                    setInputView(setInput: viewState.input)
                }
            }
            .offset(x: -Layout.size(4))
            Spacer()
        }
    }
    
    @ViewBuilder
    private func rowTitle(modifier: SetModifierViewState?) -> some View {
        HStack {
            if let modifier = modifier {
                tagView(modifier: modifier)
            } else {
                Text(viewState.title)
                    .subhead(style: .semiBold)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func setInputView(setInput: SetInputViewState) -> some View {
        switch setInput {
        case let .repsWeight(weightTitle, repsTitle, input):
            HStack(spacing: Layout.size(6)) {
                inputEntry(title: repsTitle, input: String(input.reps, defaultDash: true))
                inputEntry(title: weightTitle, input: String(input.weight, defaultDash: true))
            }
        case let .repsOnly(title, input):
            inputEntry(title: title, input: String(input.reps, defaultDash: true))
        case let .time(title, input):
            inputEntry(title: title, input: String(input.seconds, defaultDash: true))
        }
    }
    
    @ViewBuilder
    private func inputEntry(title: String, input: String) -> some View {
        VStack {
            Text(input)
                .footnote(style: .medium)
            Text(title)
                .footnote(style: .light)
        }
    }
    
    @ViewBuilder
    private func modifierView(modifier: SetModifierViewState) -> some View {
        switch modifier {
        case .dropSet(let set),
                .restPause(let set):
            setInputView(setInput: set)
        case .eccentric:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func tagView(modifier: SetModifierViewState) -> some View {
        let viewState = TagFactory.tagFromModifier(modifier: modifier,
                                                   color: userTheme.theme)
        
        Tag(viewState: viewState)
    }
}

// MARK: - View State

public struct CompletedSetViewState: Hashable {
    let title: String
    let input: SetInputViewState
    let modifier: SetModifierViewState?
    
    public init(title: String,
                type: SetInputViewState,
                modifier: SetModifierViewState? = nil) {
        self.title = title
        self.input = type
        self.modifier = modifier
    }
}
