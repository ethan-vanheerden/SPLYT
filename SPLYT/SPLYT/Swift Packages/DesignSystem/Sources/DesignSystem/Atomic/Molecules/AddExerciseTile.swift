import SwiftUI

public struct AddExerciseTile: View {
    private let viewState: AddExerciseTileViewState
    private let tapAction: () -> Void
    private let favoriteAction: () -> Void
    
    public init(viewState: AddExerciseTileViewState,
                tapAction: @escaping () -> Void,
                favoriteAction: @escaping () -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
        self.favoriteAction = favoriteAction
    }
    
    public var body: some View {
        Tile {
            HStack {
                favorite
                Text(viewState.exerciseName)
                    .descriptionText()
                Spacer()
                selection
            }
        }
        .onTapGesture {
            tapAction()
        }
    }
    
    private var favorite: some View {
        let imageName = viewState.isFavorite ? "star.fill" : "star"
        let opacity = viewState.isFavorite ? 1 : 0.5
        return Image(systemName: imageName)
            .foregroundColor(Color.splytColor(.yellow).opacity(opacity))
            .onTapGesture {
                favoriteAction()
            }
    }
    
    @ViewBuilder
    private var selection: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(Color.splytColor(.lightBlue))
            .padding(.trailing, Layout.size(2))
            .isVisible(viewState.isSelected)
    }
}

// MARK: - View State

public struct AddExerciseTileViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let exerciseName: String
    let isSelected: Bool
    let isFavorite: Bool
    
    public init(id: AnyHashable = UUID(),
                exerciseName: String,
                isSelected: Bool,
                isFavorite: Bool) {
        self.id = id
        self.exerciseName = exerciseName
        self.isSelected = isSelected
        self.isFavorite = isFavorite
    }
}

struct AddExerciseTile_Previews: PreviewProvider {
    static var previews: some View {
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
