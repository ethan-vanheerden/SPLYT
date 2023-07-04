import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class RoutineTileTests: XCTestCase {
    private let viewStateOne = RoutineTileViewState(id: "id1",
                                                    title: "Legs",
                                                    subtitle: "5 exercises")
    private let viewStateTwo = RoutineTileViewState(id: "id2",
                                                    title: "Upper Body",
                                                    subtitle: "8 exercises",
                                                    lastCompletedTitle: "Last completed: Jun 9, 2023")
    
    func testRoutineTile() throws {
        let view = VStack {
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
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
