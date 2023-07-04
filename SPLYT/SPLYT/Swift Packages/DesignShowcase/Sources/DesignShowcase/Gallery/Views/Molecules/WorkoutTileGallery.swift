import SwiftUI
import DesignSystem

struct WorkoutTileGallery: View {
    private let viewStateOne = RoutineTileViewState(id: "id1",
                                                    title: "Legs",
                                                    subtitle: "5 exercises")
    private let viewStateTwo = RoutineTileViewState(id: "id2",
                                                    title: "Upper Body",
                                                    subtitle: "8 exercises",
                                                    lastCompletedTitle: "Last completed: Jun 9, 2023")
    
    var body: some View {
        VStack {
            RoutineTile(viewState: viewStateOne,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            RoutineTile(viewState: viewStateTwo,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
