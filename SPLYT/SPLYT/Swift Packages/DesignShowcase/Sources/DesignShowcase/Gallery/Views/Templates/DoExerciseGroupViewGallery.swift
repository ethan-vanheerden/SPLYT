import SwiftUI
import DesignSystem

struct DoExerciseGroupViewGallery: View {
    typealias StateFixtures = WorkoutViewStateFixtures
    @State private var groupExpanded = true
    private let header: CollapseHeaderViewState = .init(title: "Block 1")
    private let slider: ActionSliderViewState = .init(backgroundText: "Mark as complete")
    
    var body: some View {
        ScrollView {
            VStack {
                DoExerciseGroupView(isExpanded: $groupExpanded,
                                    viewState: viewState,
                                    addSetAction: { },
                                    removeSetAction: { },
                                    updateSetAction: { _, _, _ in },
                                    updateModifierAction: { _, _, _ in },
                                    usePreviousInputAction: { _, _, _ in },
                                    addNoteAction: { },
                                    finishSlideAction: { },
                                    replaceExerciseAction: { _ in },
                                    deleteExerciseAction: { _ in },
                                    canDeleteExercise: true)
                Spacer()
            }
            .padding(.horizontal, Layout.size(2))
        }
    }
    
    private var viewState: DoExerciseGroupViewState {
        return .init(header: header,
                     exercises: exercises,
                     slider: slider)
    }
    
    private var exercises: [ExerciseViewStatus] {
        var result: [ExerciseViewStatus] = StateFixtures.fullBodyWorkoutExercises(includeHeaderLine: false)[0].map {
            .loaded($0)
        }
        
        result.append(.loading)
        return result
    }
}
