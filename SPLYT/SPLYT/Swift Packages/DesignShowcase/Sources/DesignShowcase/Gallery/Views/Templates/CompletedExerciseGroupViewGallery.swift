import SwiftUI
import DesignSystem

struct CompletedExerciseGroupViewGallery: View {
    typealias StateFixtures = WorkoutViewStateFixtures
    @State private var groupExpanded: Bool = true
    
    var body: some View {
        VStack {
            CompletedExerciseGroupView(isExpanded: $groupExpanded,
                                       viewState: .init(header: header,
                                                        exercises: exercises))
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
    
    private var header: CollapseHeaderViewState {
        return .init(title: "Group 1",
                     color: .lightBlue)
    }
    
    private var exercises: [CompletedExerciseViewState] {
        return StateFixtures.fullBodyWorkoutExercisesCompleted(includeHeaderLine: false)[0]
    }
}
