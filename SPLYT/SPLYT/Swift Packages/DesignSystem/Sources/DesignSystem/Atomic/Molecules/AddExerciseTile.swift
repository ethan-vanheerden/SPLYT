import SwiftUI

public struct AddExerciseTile: View {
    @EnvironmentObject private var userTheme: UserTheme
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
                    .body()
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
            .foregroundColor(Color(splytColor: .yellow).opacity(opacity))
            .onTapGesture {
                favoriteAction()
            }
    }
    
    @ViewBuilder
    private var selection: some View {
        HStack {
            ForEach(viewState.selectedGroups, id: \.hashValue) { groupNumber in
                Group {
                    Text("\(groupNumber + 1)")
                        .footnote()
                        .foregroundStyle(Color(splytColor: .white))
                        .background {
                            Circle()
                                .fill(Color(splytColor: userTheme.theme))
                                .frame(width: Layout.size(2.5), height: Layout.size(2.5))
                        }
                }
                .padding(.trailing, Layout.size(1))
            }
        }
        .padding(.trailing, Layout.size(1))
    }
}

// MARK: - View State

public struct AddExerciseTileViewState: Equatable, Hashable
{
    public let id: String
    public let exerciseName: String
    let selectedGroups: [Int]
    let isFavorite: Bool
    
    public init(id: String,
                exerciseName: String,
                selectedGroups: [Int],
                isFavorite: Bool) {
        self.id = id
        self.exerciseName = exerciseName
        self.selectedGroups = selectedGroups
        self.isFavorite = isFavorite
    }
}
