import SwiftUI
import DesignSystem

struct DoExerciseGroupViewGallery: View {
    typealias StateFixtures = WorkoutViewStateFixtures
    @State private var groupExpanded = true
    private let header: CollapseHeaderViewState = .init(title: "Group 1",
                                                        color: .lightBlue)
    private let exercises: [ExerciseViewState] = StateFixtures.fullBodyWorkoutExercises(includeHeaderLine: false)[0]
    private let slider: ActionSliderViewState = .init(sliderColor: .lightBlue,
                                                      backgroundText: "Mark as complete")
    private var viewState: DoExerciseGroupViewState {
        return .init(header: header,
                     exercises: exercises,
                     slider: slider)
    }
    
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
                                    finishSlideAction: { })
                Spacer()
            }
            .padding(.horizontal, Layout.size(2))
        }
    }
}
