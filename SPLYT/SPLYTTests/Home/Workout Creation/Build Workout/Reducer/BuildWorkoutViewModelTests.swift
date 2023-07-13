//
//  BuildWorkoutViewModelTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/12/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class BuildWorkoutViewModelTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    typealias ModelFixtures = WorkoutModelFixtures
    private var mockService: MockBuildWorkoutService!
    private var interactor: BuildWorkoutInteractor!
    private var sut: BuildWorkoutViewModel!
    
    override func setUpWithError() throws {
        let navState = NameWorkoutNavigationState(name: Fixtures.workoutName)
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddGroup() async {
        await load()
        await sut.send(.addGroup)
        
        let currentGroupTitle = "Current group: 0 exercises"
        let groupTitles = ["Group 1", "Group 2"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesNoneSelected,
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_AddExercise() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: true)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleExercise_RemoveExercise() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId)) // Add exercise to remove
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.addSet(group: 0))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = Array(
            repeating: (StateFixtures.emptyRepsWeightSet, nil),
            count: 2
        )
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.addSet(group: 0)) // Add set to remove
        await sut.send(.removeSet(group: 0))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_UpdateSet() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(input: .init(weight: 135, reps: 12))))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: StateFixtures.lbs,
                         repsTitle: StateFixtures.reps,
                         input: .init(weight: 135, reps: 12)), nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleFavorite_SelectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(exerciseId: ModelFixtures.backSquatId))
        
        let exerciseTileViewStates: [AddExerciseTileSectionViewState] = [
            AddExerciseTileSectionViewState(header: .init(title: "B"),
                                            exercises: [
                                                Fixtures.backSquatTileViewState(isSelected: false, isFavorite: true),
                                                Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false)
                                            ]),
            AddExerciseTileSectionViewState(header: .init(title: "I"),
                                            exercises: [
                                                Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
                                            ])
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_ToggleFavorite_DeselectFavorite() async {
        await load()
        await sut.send(.toggleFavorite(exerciseId: ModelFixtures.backSquatId)) // Mark as favorite
        await sut.send(.toggleFavorite(exerciseId: ModelFixtures.backSquatId)) // Unmark as favorite
        
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_Save_Error_SaveDialog() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        mockService.saveWorkoutThrow = true
        await sut.send(.save)
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: .save,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_Save_Success() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.save)
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_AddModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(input: .init(weight: 135, reps: 8)))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(input: .init()))))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: StateFixtures.lbs,
                         repsTitle: StateFixtures.reps,
                         input: .init(weight: 135, reps: 8)),
             .dropSet(set: .repsWeight(weightTitle: StateFixtures.lbs,
                                       repsTitle: StateFixtures.reps)))
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_RemoveModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(input: .init(weight: 135, reps: 8)))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(input: .init())))) // Add to remove
        await sut.send(.removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: StateFixtures.lbs,
                         repsTitle: StateFixtures.reps,
                         input: .init(weight: 135, reps: 8)), nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
    
    func testSend_UpdateModifier() async {
        await load()
        await sut.send(.toggleExercise(exerciseId: ModelFixtures.backSquatId))
        await sut.send(.updateSet(group: 0,
                                  exerciseIndex: 0,
                                  setIndex: 0,
                                  with: .repsWeight(input: .init(weight: 135, reps: 8)))) // Update normal set as well
        await sut.send(.addModifier(group: 0,
                                    exerciseIndex: 0,
                                    setIndex: 0,
                                    modifier: .dropSet(input: .repsWeight(input: .init()))))
        await sut.send(.updateModifier(group: 0,
                                       exerciseIndex: 0,
                                       setIndex: 0,
                                       with: .repsWeight(input: .init(weight: 100, reps: 5))))
        
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: StateFixtures.lbs,
                         repsTitle: StateFixtures.reps,
                         input: .init(weight: 135, reps: 8)),
             .dropSet(set: .repsWeight(weightTitle: StateFixtures.lbs,
                                       repsTitle: StateFixtures.reps,
                                       input: .init(weight: 100, reps: 5))))
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: Fixtures.exerciseTilesBackSquatSelected,
                                                  groups: groups,
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(sut.viewState, .main(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildWorkoutViewModelTests {
    func load() async {
        _ = await sut.send(.load)
    }
}
