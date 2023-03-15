
import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class AddExerciseTileTests: XCTestCase {
    func testAddExerciseTile() throws {
        let view = VStack {
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
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
