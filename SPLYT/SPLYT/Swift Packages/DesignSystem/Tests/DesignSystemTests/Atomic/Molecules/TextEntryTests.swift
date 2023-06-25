import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class WorkoutTileTests: XCTestCase {
    private let viewStateOne = WorkoutTileViewState(id: "id1",
                                                    workoutName: "Legs",
                                                    numExercises: "5 exercises")
    private let viewStateTwo = WorkoutTileViewState(id: "id2",
                                                    workoutName: "Upper Body",
                                                    numExercises: "8 exercises",
                                                    lastCompleted: "Last completed: Jun 9, 2023")
    
    func testWorkoutTile() throws {
        let view = VStack {
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
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
