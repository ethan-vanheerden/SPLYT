import SwiftUI
import DesignSystem

struct AddExerciseTileGallery: View {
    var body: some View {
        VStack {
            AddExerciseTile(viewState: AddExerciseTileViewState(exerciseName: "BACK SQUAT",
                                                                isSelected: false,
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(exerciseName: "BENCH PRESS",
                                                                isSelected: true,
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(exerciseName: "POWER CLEAN",
                                                                isSelected: false,
                                                                isFavorite: true),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(exerciseName: "LAT PULLDOWN",
                                                                isSelected: true,
                                                                isFavorite: true),
                            tapAction: { },
                            favoriteAction: { })
            Spacer()
        }
        .padding(.horizontal)
    }
}
