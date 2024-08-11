//
//  BuildWorkoutReducerTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/11/23.
//

import XCTest
@testable import SPLYT
@testable import DesignSystem
@testable import ExerciseCore

final class BuildWorkoutReducerTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    typealias StateFixtures = WorkoutViewStateFixtures
    typealias ModelFixtures = WorkoutModelFixtures
    private let sut = BuildWorkoutReducer()
    private var interactor: BuildWorkoutInteractor! // Used to construct the domain object
    
    override func setUpWithError() throws {
        let navState = NameWorkoutNavigationState(name: Fixtures.workoutName)
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
                                                  shownDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    // After modifying the workout a bit
    func testReduce_Loaded_BuiltWorkout() async {
        await loadExercises()
        _ = await interactor.interact(with: .toggleExercise(exerciseId: ModelFixtures.backSquatId))
        _ = await interactor.interact(with: .toggleExercise(exerciseId: ModelFixtures.benchPressId))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addSet(group: 0))
        _ = await interactor.interact(with: .addGroup)
        _ = await interactor.interact(with: .toggleExercise(exerciseId: ModelFixtures.inclineRowId))
        _ = await interactor.interact(with: .toggleExercise(exerciseId: ModelFixtures.backSquatId))
        _ = await interactor.interact(with: .updateSet(group: 0,
                                                       exerciseIndex: 0,
                                                       setIndex: 0,
                                                       with: .repsWeight(input: .init(weight: 135, reps: 12))))
        _ = await interactor.interact(with: .addModifier(group: 0,
                                                         exerciseIndex: 1,
                                                         setIndex: 2,
                                                         modifier: .dropSet(input: .repsWeight(input: .init(weight: 100,
                                                                                                            reps: 5)))))
        var domain = await interactor.interact(with: .toggleFavorite(exerciseId: ModelFixtures.inclineRowId))
        var result = sut.reduce(domain)
        
        var exerciseTileViewStates: [AddExerciseTileSectionViewState] = [
            AddExerciseTileSectionViewState(header: .init(title: "B"),
                                            exercises: [
                                                Fixtures.backSquatTileViewState(selectedGroups: [0, 1], isFavorite: false),
                                                Fixtures.benchPressTileViewState(selectedGroups: [0], isFavorite: false)
                                            ]),
            AddExerciseTileSectionViewState(header: .init(title: "I"),
                                            exercises: [
                                                Fixtures.inclineDBRowTileViewState(selectedGroups: [1], 
                                                                                   isFavorite: true)
                                            ])
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
        let squatSetsTwo: [(SetInputViewState, SetModifierViewState?)] = [
            (StateFixtures.emptyRepsWeightSet, nil)
        ]
        let groups: [[ExerciseViewState]] = [
            [StateFixtures.backSquatViewState(inputs: squatSets), StateFixtures.benchPressViewState(inputs: benchSets)],
            [StateFixtures.inclineDBRowViewState(inputs: rowSets), StateFixtures.backSquatViewState(inputs: squatSetsTwo)]
        ]
        let currentGroupTitle = "Current group: 2 exercises"
        let groupTitles = ["Group 1", "Group 2"]
        var expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                                  groups: groups,
                                                  currentGroup: 1,
                                                  currentGroupTitle: currentGroupTitle,
                                                  groupTitles: groupTitles,
                                                  lastGroupEmpty: false,
                                                  shownDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(result, .main(expectedDisplay))
        
        // Adding some filters
        domain = await interactor.interact(with: .filter(by: .search(searchText: "row")))
        result = sut.reduce(domain)
        
        exerciseTileViewStates = [
            AddExerciseTileSectionViewState(header: .init(title: "I"),
                                            exercises: [
                                                Fixtures.inclineDBRowTileViewState(selectedGroups: [1],
                                                                                   isFavorite: true)
                                            ])
        ]
        expectedDisplay = BuildWorkoutDisplay(allExercises: exerciseTileViewStates,
                                              groups: groups,
                                              currentGroup: 1,
                                              currentGroupTitle: currentGroupTitle,
                                              groupTitles: groupTitles,
                                              lastGroupEmpty: false,
                                              shownDialog: nil,
                                              backDialog: Fixtures.backDialog,
                                              saveDialog: Fixtures.saveDialog,
                                              canSave: true,
                                              filterDisplay: Fixtures.emptyFilterDisplay,
                                              isFiltering: false) // Not filtering since just search
        
        XCTAssertEqual(result, .main(expectedDisplay))
        
        _ = await interactor.interact(with: .filter(by: .favorite(isFavorite: true)))
        domain = await interactor.interact(with: .filter(by: .muscleWorked(muscle: .glutes, isSelected: true)))
        result = sut.reduce(domain)
        
        var musclesWorkedMap = Fixtures.musclesWorkedMap
        musclesWorkedMap[.glutes] = true
        let filterDisplay = BuildWorkoutFilterDisplay(isFavorite: true,
                                                      musclesWorked: musclesWorkedMap)
        expectedDisplay = BuildWorkoutDisplay(allExercises: [],
                                              groups: groups,
                                              currentGroup: 1,
                                              currentGroupTitle: currentGroupTitle,
                                              groupTitles: groupTitles,
                                              lastGroupEmpty: false,
                                              shownDialog: nil,
                                              backDialog: Fixtures.backDialog,
                                              saveDialog: Fixtures.saveDialog,
                                              canSave: true,
                                              filterDisplay: filterDisplay,
                                              isFiltering: true)
        
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
                                                  shownDialog: .leave,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
                                                  shownDialog: .save,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: false,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
        XCTAssertEqual(result, .main(expectedDisplay))
    }
    
    func testReduce_Exit() async {
        await loadExercises()
        _ = await interactor.interact(with: .toggleExercise(exerciseId: ModelFixtures.backSquatId))
        let domain = await interactor.interact(with: .save)
        let result = sut.reduce(domain)
        
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
                                                  shownDialog: nil,
                                                  backDialog: Fixtures.backDialog,
                                                  saveDialog: Fixtures.saveDialog,
                                                  canSave: true,
                                                  filterDisplay: Fixtures.emptyFilterDisplay,
                                                  isFiltering: false)
        
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
