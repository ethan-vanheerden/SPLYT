
import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class AddExerciseTileTests: XCTestCase {
    func testAddExerciseTile() throws {
        let view = VStack {
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "back-squat",
                                                                exerciseName: "BACK SQUAT",
                                                                selectedGroups: [],
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "bench-press",
                                                                exerciseName: "BENCH PRESS",
                                                                selectedGroups: [0],
                                                                isFavorite: false),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "power-clean",
                                                                exerciseName: "POWER CLEAN",
                                                                selectedGroups: [0, 1],
                                                                isFavorite: true),
                            tapAction: { },
                            favoriteAction: { })
            AddExerciseTile(viewState: AddExerciseTileViewState(id: "lat-pulldown",
                                                                exerciseName: "LAT PULLDOWN",
                                                                selectedGroups: [],
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
