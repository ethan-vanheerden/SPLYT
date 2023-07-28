import SwiftUI

public struct CompletedExerciseGroupView: View {
    @Binding private var isExpanded: Bool
    private let viewState: CompletedExerciseGroupViewState
    
    public init(isExpanded: Binding<Bool>,
                viewState: CompletedExerciseGroupViewState) {
        self._isExpanded = isExpanded
        self.viewState = viewState
    }
    
    public var body: some View {
        CollapseHeader(isExpanded: $isExpanded,
                       viewState: viewState.header) {
            VStack {
                ForEach(viewState.exercises, id: \.self) { exerciseState in
                    CompletedExerciseView(viewState: exerciseState)
                }
                .padding(.all, Layout.size(1))
            }
        }
    }
}

// MARK: - View State

public struct CompletedExerciseGroupViewState: Hashable {
    let header: CollapseHeaderViewState
    let exercises: [CompletedExerciseViewState]
    
    public init(header: CollapseHeaderViewState,
                exercises: [CompletedExerciseViewState]) {
        self.header = header
        self.exercises = exercises
    }
}
