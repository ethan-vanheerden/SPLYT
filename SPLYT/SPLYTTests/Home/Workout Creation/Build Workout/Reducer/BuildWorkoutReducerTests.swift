//
//  BuildWorkoutReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/11/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
import ExerciseCore

final class BuildWorkoutReducerTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
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
                                                  groups: [[]],
                                                  currentGroup: 0,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: true,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    // After modifying the workout a bit
    func testReduce_Loaded_BuiltWorkout() async {
        await loadExercises()
        _ = await interactor.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await interactor.interact(with: .toggleExercise(exerciseId: "bench-press", group: 0))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addGroup)
        _ = await interactor.interact(with: .toggleExercise(exerciseId: "incline-db-row", group: 1))
        _ = await interactor.interact(with: .updateSet(group: 0,
                                                       exerciseIndex: 0,
                                                       setIndex: 0,
                                                       with: .repsWeight(input: .init(weight: 135, reps: 12))))
        _ = await interactor.interact(with: .addModifier(group: 0,
                                                         exerciseIndex: 1,
                                                         setIndex: 2,
                                                         modifier: .dropSet(input: .repsWeight(input: .init(weight: 100,
                                                                                                            reps: 5)))))
        let domain = await interactor.interact(with: .toggleFavorite(exerciseId: "incline-db-row"))
        let result = sut.reduce(domain)
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: true, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: true, isFavorite: true)
        ]
        let squatSets: [(SetInputViewState, SetModifierViewState?)] = [
            (.repsWeight(weightTitle: StateFixtures.lbs,
                         repsTitle: StateFixtures.reps,
                         input: .init(weight: 135, reps: 12)), nil),
            (StateFixtures.emptyRepsWeightSet, nil),
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let benchSets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil),
            (StateFixtures.emptyRepsWeightSet, nil),
            (StateFixtures.emptyRepsWeightSet,
             .dropSet(set: .repsWeight(weightTitle: StateFixtures.lbs,
                                       repsTitle: StateFixtures.reps,
                                       input: .init(weight: 100, reps: 5))))
        ]
        let rowSets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: squatSets), StateFixtures.benchPressViewState(inputs: benchSets)],
            [StateFixtures.inclineDBRowViewState(inputs: rowSets)]
        ]
        let currentGroupTitle = "Current group: 1 exercise"
        let groupTitles = ["Group 1", "Group 2"]
        let expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 1, currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  showDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_BackDialog() async {
        await loadExercises()
        let domain = await interactor.interact(with: .toggleDialog(type: .leave, isOpen: true))
        let result = sut.reduce(domain)
        
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
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_SaveDialog() async {
        await loadExercises()
        let domain = await interactor.interact(with: .toggleDialog(type: .save, isOpen: true))
        let result = sut.reduce(domain)
        
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
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_Exit() async {
        await loadExercises()
        _ = await interactor.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        let domain = await interactor.interact(with: .save)
        let result = sut.reduce(domain)
        
        let exerciseTileViewStates = [
            Fixtures.backSquatTileViewState(isSelected: true, isFavorite: false),
            Fixtures.benchPressTileViewState(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowTileViewState(isSelected: false, isFavorite: false)
        ]
        let sets: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: sets)]
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
        
        XCTAssertEqual(result, .exit(expectedDisplay))
    }
}

// MARK: - Private

private extension BuildWorkoutReducerTests {
    @discardableResult
    func loadExercises() async -> BuildWorkoutDomainResult {
        return await interactor.interact(with: .loadExercises)
    }
}
