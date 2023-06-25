import SwiftUI
import DesignSystem

struct WorkoutTileGallery: View {
    private let viewStateOne = WorkoutTileViewState(id: "id1",
                                                    workoutName: "Legs",
                                                    numExercises: "5 exercises")
    private let viewStateTwo = WorkoutTileViewState(id: "id2",
                                                    workoutName: "Upper Body",
                                                    numExercises: "8 exercises",
                                                    lastCompleted: "Last completed: Jun 9, 2023")
    
    var body: some View {
        VStack {
            WorkoutTile(viewState: viewStateOne,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            WorkoutTile(viewState: viewStateTwo,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
