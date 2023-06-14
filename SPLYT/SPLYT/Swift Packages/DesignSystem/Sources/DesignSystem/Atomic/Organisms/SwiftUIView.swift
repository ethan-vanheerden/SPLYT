import SwiftUI

public struct AddExerciseTileSection: View {
    private let viewState: AddExerciseTileSectionViewState
    
    public init(viewState: AddExerciseTileSectionViewState) {
        self.viewState = viewState
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(viewState.exercises, id: \.id) { exerciseViewState in
                        AddExerciseTile(viewState: exerciseViewState,
                                        tapAction: { },
                                        favoriteAction: { })
                    }
                } header: {
                    SectionHeader(viewState: viewState.header)
                }
            }
        }
    }
}

// MARK: - View State

public struct AddExerciseTileSectionViewState: Equatable, Hashable {
    public let header: SectionHeaderViewState
    public let exercises: [AddExerciseTileViewState]
    
    public init(header: SectionHeaderViewState,
                exercises: [AddExerciseTileViewState]) {
        self.header = header
        self.exercises = exercises
    }
}
