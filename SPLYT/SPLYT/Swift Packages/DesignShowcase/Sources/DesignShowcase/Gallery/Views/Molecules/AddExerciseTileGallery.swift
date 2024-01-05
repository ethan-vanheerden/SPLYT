import SwiftUI
import DesignSystem

struct AddExerciseTileGallery: View {
    var body: some View {
        VStack {
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "id1",
                                                                exerciseName: "BACK SQUAT",
                                                                selectedGroups: [],
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "id2",
                                                                exerciseName: "BENCH PRESS",
                                                                selectedGroups: [0],
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "id3",
                                                                exerciseName: "POWER CLEAN",
                                                                selectedGroups: [],
                                                                isFavorite: true),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "id4",
                                                                exerciseName: "LAT PULLDOWN",
                                                                selectedGroups: [1, 2, 3],
                                                                isFavorite: true),
                            tapAction: { },
                            favoriteAction: { })
            Spacer()
        }
        .padding(.horizontal)
    }
}
