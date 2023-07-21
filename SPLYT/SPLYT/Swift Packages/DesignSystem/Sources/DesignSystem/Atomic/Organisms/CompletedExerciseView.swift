import SwiftUI

public struct CompletedExerciseView: View {
    private let viewState: CompletedExerciseViewState
    
    public init(viewState: CompletedExerciseViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        Tile {
            VStack(spacing: Layout.size(1.5)) {
                SectionHeader(viewState: viewState.header)
                ForEach(viewState.sets, id: \.self) { setState in
                    CompletedSetView(viewState: setState)
                }
            }
        }
    }
}

// MARK: - View State

public struct CompletedExerciseViewState: Hashable {
    let header: SectionHeaderViewState
    let sets: [CompletedSetViewState]
    
    public init(header: SectionHeaderViewState,
                sets: [CompletedSetViewState]) {
        self.header = header
        self.sets = sets
    }
}
