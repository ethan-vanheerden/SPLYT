//
//  BuildWorkoutReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/11/23.
//

import XCTest
@testable import SPLYT
import DesignSystem

final class BuildWorkoutReducerTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private let sut = BuildWorkoutReducer()
    private var interactor: BuildWorkoutInteractor! // Used to construct the domain object
    
    override func setUpWithError() throws {
        let navState = NameWorkoutNavigationState(workoutName: "Test Workout")
        self.interactor = BuildWorkoutInteractor(service: MockBuildWorkoutService(),
                                          nameState: navState)
    }
    
    func testReduce_Error() {
        let result = sut.reduce(.error)
        XCTAssertEqual(result, .error)
    }
    
    func testReduce_Loaded_StartingScreen() async {
        let domain = await loadExercises()
        let result = sut.reduce(domain)
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]], currentGroup: 0, currentGroupTitle: currentGroupTitle, groupTitles: groupTitles)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    // After modifying the workout a bit
    func testReduce_Loaded_BuiltWorkout() async {
        await loadExercises()
        _ = await interactor.interact(with: .toggleExercise(id: "back-squat", group: 0))
        _ = await interactor.interact(with: .toggleExercise(id: "bench-press", group: 0))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addGroup)
        _ = await interactor.interact(with: .toggleExercise(id: "incline-db-row", group: 1))
        let domain = await interactor.interact(with: .toggleFavorite(id: "incline-db-row"))
        let result = sut.reduce(domain)
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: true, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: true, isFavorite: true)
        ]
        let groups: [[BuildExerciseViewState]] = [
            [Fixtures.backSquatViewState(numSets: 3), Fixtures.benchPressViewState(numSets: 3)],
            [Fixtures.inclineDBRowViewState(numSets: 1)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1", "Group 2"]
        
        // TODO: SPLYT-31: test for set inputs
        
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 1, currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildWorkoutReducerTests {
    @discardableResult
    func loadExercises() async -> BuildWorkoutDomainResult {
        return await interactor.interact(with: .loadExercises)
    }
}
