//
//  BuildWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/12/23.
//

import XCTest
@testable import SPLYT
import DesignSystem

/// Tests are pretty straightforward as the Interactor and Reducer tests handle the edge cases
final class BuildWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private var interactor: BuildWorkoutInteractor!
    private var sut: BuildWorkoutViewModel!
    
    override func setUpWithError() throws {
        let navState = NameWorkoutNavigationState(workoutName: "Test Workout")
        self.interactor = BuildWorkoutInteractor(service: MockBuildWorkoutService(),
                                                 nameState: navState)
        self.sut = BuildWorkoutViewModel(interactor: interactor)
    }
    
    func testLoadingOnInit() {
        XCTAssertEqual(sut.viewState, .loading)
    }
    
    func testSend_Load() async {
        await sut.send(.load)
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddGroup() async {
        await load()
        await sut.send(.addGroup)
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1", "Group 2"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[], []],
                                                  currentGroup: 1,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveGroup() async {
        await load()
        await sut.send(.addGroup) // Add a group to remove
        await sut.send(.removeGroup(group: 1))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle:
                                                    currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_AddExercise() async {
        await load()
        await sut.send(.toggleExercise(id: "back-squat", group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let groups: [[BuildExerciseViewState]] = [
            [Fixtures.backSquatViewState(numSets: 1)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_RemoveExercise() async {
        await load()
        await sut.send(.toggleExercise(id: "back-squat", group: 0)) // Add exercise to remove
        await sut.send(.toggleExercise(id: "back-squat", group: 0))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddSet() async {
        await load()
        await sut.send(.toggleExercise(id: "back-squat", group: 0))
        await sut.send(.addSet(group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let groups: [[BuildExerciseViewState]] = [
            [Fixtures.backSquatViewState(numSets: 2)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveSet() async {
        await load()
        await sut.send(.toggleExercise(id: "back-squat", group: 0))
        await sut.send(.addSet(group: 0)) // Add set to remove
        await sut.send(.removeSet(group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let groups: [[BuildExerciseViewState]] = [
            [Fixtures.backSquatViewState(numSets: 1)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    // TODO: SPLYT-31: updateSet tests
    
    func testSend_ToggleFavorite_SelectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(id: "back-squat"))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: false, isFavorite: true),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleFavorite_DeselectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(id: "back-squat")) // Mark as favorite
        await sut.send(.toggleFavorite(id: "back-squat")) // Unmark as favorite
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_SwitchGroup() async {
        await load()
        await sut.send(.addGroup) // Add a group to switch to
        await sut.send(.switchGroup(to: 1))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1", "Group 2"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[], []],
                                                  currentGroup: 1,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    // TODO: SPYLT-26: test save
    
    func testSend_ToggleDialog_OpenDialog() async {
        await sut.send(.load)
        await sut.send(.toggleLeaveDialog(isOpen: true))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: true,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleDialog_CloseDialog() async {
        await sut.send(.load)
        await sut.send(.toggleLeaveDialog(isOpen: true)) // Open dialog so we can close it
        await sut.send(.toggleLeaveDialog(isOpen: false))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  dialogOpen: false,
                                                  dialog: Fixtures.dialogViewState)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildWorkoutViewModelTests {
    func load() async {
        _ = await sut.send(.load)
    }
}
