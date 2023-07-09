import SwiftUI
import ExerciseCore

// TODO: Worry about this when we do workout history
public struct CompletedSetView: View {
    private let viewState: CompletedSetViewState
    
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
            if let progression = viewState.progression { // fix me
                progressionView(status: progression)
            } else {
                Image(systemName: "chart.line.uptrend.xyaxis.circle")
                    .imageScale(.large)
                    .isVisible(false) // Hide so we keep spacing consistent
            }
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
                inputEntry(title: repsTitle, input: String(input.reps))
                inputEntry(title: weightTitle, input: String(input.weight))
            }
        case let .repsOnly(title, input):
            inputEntry(title: title, input: String(input.reps))
        case let .time(title, input):
            inputEntry(title: title, input: String(input.seconds))
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
        let viewState = TagFactory.tagFromModifier(modifier: modifier)
        
        Tag(viewState: viewState)
    }
    
    private func progressionView(status: SetProgressionStatus) -> some View {
        let imageName: String
        let imageColor: SplytColor
        
        switch status {
        case .positive:
            imageName = "chart.line.uptrend.xyaxis.circle"
            imageColor = .green
        case .negative:
            imageName = "chart.line.downtrend.xyaxis.circle"
            imageColor = .red
        case .neutral:
            imageName = "chart.line.flattrend.xyaxis.circle"
            imageColor = .gray
        }
        
        return Image(systemName: imageName)
            .foregroundColor(Color(splytColor: imageColor))
            .imageScale(.large)
    }
}

// MARK: - View State

public struct CompletedSetViewState: Hashable {
    let title: String
    let input: SetInputViewState
    let modifier: SetModifierViewState?
    let progression: SetProgressionStatus?
    
    public init(title: String,
                type: SetInputViewState,
                modifier: SetModifierViewState? = nil,
                progression: SetProgressionStatus? = nil) {
        self.title = title
        self.input = type
        self.modifier = modifier
        self.progression = progression
    }
}

// MARK: - Status

public enum SetProgressionStatus: Equatable {
    case positive // Increase in volume
    case negative // Decrease in volume
    case neutral // No change in volume
}
