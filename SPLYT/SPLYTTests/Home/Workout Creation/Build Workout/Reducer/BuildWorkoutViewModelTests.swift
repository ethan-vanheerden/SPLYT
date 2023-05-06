//
//  BuildWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/12/23.
//

import XCTest
@testable import SPLYT
import DesignSystem
import ExerciseCore

/// Tests are pretty straightforward as the Interactor and Reducer tests handle the edge cases
final class BuildWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private var mockService: MockBuildWorkoutService!
    private var interactor: BuildWorkoutInteractor!
    private var sut: BuildWorkoutViewModel!
    
    override func setUpWithError() throws {
        let navState = NameWorkoutNavigationState(workoutName: "Test Workout")
        self.mockService = MockBuildWorkoutService()
        self.interactor = BuildWorkoutInteractor(service: mockService,
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
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
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
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
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
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_AddExercise() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (Fixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_RemoveExercise() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0)) // Add exercise to remove
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.addSet(group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = Array(
            repeating: (Fixtures.emptyRepsWeightSet, nil),
            count: 2
        )
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.addSet(group: 0)) // Add set to remove
        await sut.send(.removeSet(group: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (Fixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_UpdateSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(reps: 12, weight: 135)))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: Fixtures.lbs, weight: 135, repsTitle: Fixtures.reps, reps: 12), nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleFavorite_SelectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(exerciseId: "back-squat"))
        
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
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleFavorite_DeselectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(exerciseId: "back-squat")) // Mark as favorite
        await sut.send(.toggleFavorite(exerciseId: "back-squat")) // Unmark as favorite
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
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
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_Save_Error_SaveDialog() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        mockService.saveWorkoutThrow = true
        await sut.send(.save)
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (Fixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: .save,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_Save_Success() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.save)
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (Fixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .exit(expectedDisplay))
    }
    
    func testSend_ToggleDialog_Leave_OpenDialog() async {
        await load()
        await sut.send(.toggleDialog(type: .leave, isOpen: true))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: .leave,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleDialog_Save_OpenDialog() async {
        await load()
        await sut.send(.toggleDialog(type: .save, isOpen: true))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: .save,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleDialog_CloseDialog() async {
        await load()
        await sut.send(.toggleDialog(type: .leave, isOpen: true)) // Open dialog so we can close it
        await sut.send(.toggleDialog(type: .leave, isOpen: false))
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(reps: 8, weight: 135))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(reps: nil, weight: nil))))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: "lbs", weight: 135, repsTitle: "reps", reps: 8),
             .dropSet(set: .repsWeight(weightTitle: "lbs", repsTitle: "reps")))
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(reps: 8, weight: 135))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(reps: nil, weight: nil)))) // Add to remove
        await sut.send(.removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: "lbs", weight: 135, repsTitle: "reps", reps: 8), nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_UpdateModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: "back-squat", group: 0))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(reps: 8, weight: 135))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(reps: nil, weight: nil))))
        await sut.send(.updateModifier(group: 0,
                                       exerciseIndex: 0,
                                       setIndex: 0,
                                       with: .repsWeight(reps: 5, weight: 100)))
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: "lbs", weight: 135, repsTitle: "reps", reps: 8),
             .dropSet(set: .repsWeight(weightTitle: "lbs", weight: 100, repsTitle: "reps", reps: 5)))
        ]
        let groups: [[ExerciseViewState]] = [
            [Fixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildWorkoutViewModelTests {
    func load() async {
        _ = await sut.send(.load)
    }
}
