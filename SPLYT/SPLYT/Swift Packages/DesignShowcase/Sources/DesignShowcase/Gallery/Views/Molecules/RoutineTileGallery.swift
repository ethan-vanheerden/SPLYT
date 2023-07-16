import SwiftUI
import DesignSystem

struct RoutineTileGallery: View {
    private let viewStateOne = RoutineTileViewState(id: "id1",
                                                    title: "Legs",
                                                    subtitle: "5 exercises")
    private let viewStateTwo = RoutineTileViewState(id: "id2",
                                                    title: "Upper Body",
                                                    subtitle: "8 exercises",
                                                    lastCompletedTitle: "Last completed: Jun 9, 2023")
    private let viewStateThree = RoutineTileViewState(id: "id3",
                                                      title: "Arms",
                                                      subtitle: "6 exercises",
                                                      includeIcon: false)
    
    var body: some View {
        VStack(spacing: Layout.size(2)) {
            RoutineTile(viewState: viewStateOne,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            RoutineTile(viewState: viewStateTwo,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            RoutineTile(viewState: viewStateThree,
                        tapAction: { },
                        editAction: { },
                        deleteAction: { })
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
