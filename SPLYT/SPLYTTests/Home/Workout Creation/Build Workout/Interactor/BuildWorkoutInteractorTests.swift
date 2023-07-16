//
//  BuildWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import XCTest
@testable import ExerciseCore
@testable import SPLYT

final class BuildWorkoutInteractorTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockBuildWorkoutService!
    private var navState: NameWorkoutNavigationState!
    private var sut: BuildWorkoutInteractor!
    
    override func setUpWithError() throws {
        self.mockService = MockBuildWorkoutService()
        self.navState = NameWorkoutNavigationState(name: Fixtures.workoutName)
        self.sut = BuildWorkoutInteractor(service: mockService,
                                          nameState: navState,
                                          creationDate: WorkoutFixtures.jan_1_2023_0800)
    }
    
    func testInteract_LoadExercises_ServiceError() async {
        mockService.loadExercisesThrow = true
        let result = await sut.interact(with: .loadExercises)
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_LoadExercises_Success() async {
        let result = await loadExercises()
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddGroup_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addGroup)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddGroup_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .addGroup)
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        groupMap[1] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeGroup(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveGroup_OnlyOneGroup_DoesNothing() async {
        await loadExercises()
        let result = await sut.interact(with: .removeGroup(group: 0))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_InvalidGroup_DoesNothing() async {
        await loadExercises()
        let result = await sut.interact(with: .removeGroup(group: 1)) // Not a group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_NotFirst_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup) // Add a group to remove
        let result = await sut.interact(with: .removeGroup(group: 1)) // Remove the added group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_First_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup) // Add a group to remove
        let result = await sut.interact(with: .removeGroup(group: 0)) // Remove the first group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_OnCurrentGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .switchGroup(to: 0)) // Go back to first group
        let result = await sut.interact(with: .removeGroup(group: 0)) // Remove our current group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_ExerciseNoExist_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: "this-exercise-doesn't-exist"))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_AddExercise_OnlyExerciseInGroup_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_AddExercise_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // Add a starting exercise
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to the exercise
        let result = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init()), nil),
            count: 2
        )
        groupMap[0] = [
            WorkoutFixtures.backSquat(inputs: sets),
            WorkoutFixtures.benchPress(inputs: sets) // Added exercises has 2 sets as well
        ]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_RemoveExercise_OnlyExerciseInOneGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // First add the exercise
        let result = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // Removes it
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_RemoveExercise_LastExerciseInGroup_RemovesGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // First add the exercise
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId)) // Add to new group
        let result = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // Now removes it
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        groupMap[0] = [
            WorkoutFixtures.benchPress(inputs: sets) // Now in group 0
        ]
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addSet(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddSet_OneExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        let result = await sut.interact(with: .addSet(group: 0))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init()), nil),
            count: 2
        )
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .addSet(group: 0)) // Add multiple sets
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init()), nil),
            count: 3
        )
        groupMap[0] = [
            WorkoutFixtures.backSquat(inputs: sets),
            WorkoutFixtures.benchPress(inputs: sets)
        ]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeSet(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveSet_NoExericsesInGroup_DoesNothing() async {
        await loadExercises()
        let result = await sut.interact(with: .removeSet(group: 0))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OnlyOneSetInGroup_DoesNothing() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: [
            (.repsWeight(input: .init()), nil)])
        ]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OneExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to remove
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init()), nil),
            count: 2
        )
        groupMap[0] = [
            WorkoutFixtures.backSquat(inputs: sets),
            WorkoutFixtures.benchPress(inputs: sets)
        ]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: .repsWeight(input: .init(weight: 135, reps: 12))))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateSet_FirstSet_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // One set automatically added
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: .repsWeight(input: .init(weight: 135, reps: 12))))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init(weight: 135, reps: 12)), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_NestedSet_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.inclineRowId))
        _ = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 1))
        let result = await sut.interact(with: .updateSet(group: 1,
                                                         exerciseIndex: 1,
                                                         setIndex: 1,
                                                         with: .repsWeight(input: .init(weight: 135, reps: 12))))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: true),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: true, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let group1Sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        let benchSets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init()), nil),
            count: 2
        )
        let rowSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil),
            (.repsWeight(input: .init(weight: 135, reps: 12)), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: group1Sets)]
        groupMap[1] = [
            WorkoutFixtures.benchPress(inputs: benchSets),
            WorkoutFixtures.inclineDBRow(inputs: rowSets)
        ]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_AddedSetsAfterAlsoUpdated_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId)) // One set automatically added
        _ = await sut.interact(with: .updateSet(group: 0,
                                                exerciseIndex: 0,
                                                setIndex: 0,
                                                with: .repsWeight(input: .init(weight: 135, reps: 12))))
        let result = await sut.interact(with: .addSet(group: 0)) // Added set should have updated input as well
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(
            repeating: (.repsWeight(input: .init(weight: 135, reps: 12)), nil),
            count: 2
        )
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleFavorite_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleFavorite_ServiceError_Error() async {
        await loadExercises()
        mockService.saveExercisesThrow = true
        let result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveExercisesCalled)
    }
    
    func testInteract_ToggleFavorite_SelectFavorite_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: true),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleFavorite_DeselectFavorite_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId)) // Mark as favorite
        let result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId)) // Unmark as favorite
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_SwitchGroup_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .switchGroup(to: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_SwitchGroup_InvalidGroup_Error() async {
        await loadExercises()
        let resultOne = await sut.interact(with: .switchGroup(to: -1))
        let resultTwo = await sut.interact(with: .switchGroup(to: 1)) // Not created
        
        XCTAssertEqual(resultOne, .error)
        XCTAssertEqual(resultTwo, .error)
    }
    
    func testInteract_SwitchGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup) // Add a group to switch to
        let result = await sut.interact(with: .switchGroup(to: 1))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        groupMap[1] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 2,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Save_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .save)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Save_ServiceError_Dialog() async {
        await loadExercises()
        mockService.saveWorkoutThrow = true
        let result = await sut.interact(with: .save)
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .dialog(type: .save, domain: expectedDomain))
    }
    
    func testInteract_Save_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .save)
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertTrue(mockService.saveWorkoutCalled)
        XCTAssertEqual(result, .exit(expectedDomain))
    }
    
    func testInteract_Save_CustomSave_Success() async {
        var workout: Workout?// Will hold the saved workout
        sut = BuildWorkoutInteractor(service: mockService,
                                     nameState: navState,
                                     creationDate: WorkoutFixtures.jan_1_2023_0800,
                                     saveAction: { workout = $0 })
        
        await loadExercises()
        let result = await sut.interact(with: .save)
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let expectedWorkout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                                   groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: expectedWorkout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertFalse(mockService.saveWorkoutCalled)
        XCTAssertEqual(workout, expectedWorkout)
        XCTAssertEqual(result, .exit(expectedDomain))
        
    }
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(type: .leave, isOpen: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_OpenLeave_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleDialog(type: .leave, isOpen: true))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .dialog(type: .leave, domain: expectedDomain))
    }
    
    func testInteract_ToggleDialog_OpenSave_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleDialog(type: .save, isOpen: true))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .dialog(type: .save, domain: expectedDomain))
    }
    
    func testInteract_ToggleDialog_Close_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleDialog(type: .leave, isOpen: true)) // Open dialog so we can close it
        let result = await sut.interact(with: .toggleDialog(type: .leave, isOpen: false))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddModifier_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addModifier(group: 0,
                                                           exerciseIndex: 0,
                                                           setIndex: 0,
                                                           modifier: .eccentric))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddModifier_FirstGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        let result = await sut.interact(with: .addModifier(group: 0,
                                                           exerciseIndex: 0,
                                                           setIndex: 0,
                                                           modifier: .eccentric))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(input: .init()), .eccentric)]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(input:
                                                        .init(weight: 135, reps: 8)))) // Add some inputs as well
        let result = await sut.interact(with: .addModifier(group: 1,
                                                           exerciseIndex: 0,
                                                           setIndex: 1,
                                                           modifier: .dropSet(input:
                                                                .repsWeight(input: .init(weight: 100)))))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil),
            (.repsWeight(input: .init(weight: 135, reps: 8)),
             .dropSet(input: .repsWeight(input: .init(weight: 100))))
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [WorkoutFixtures.benchPress(inputs: benchSets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveModifier_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveModifier_FirstGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addModifier(group: 0,
                                                  exerciseIndex: 0,
                                                  setIndex: 0,
                                                  modifier: .eccentric)) // Add modifier to remove
        let result = await sut.interact(with: .removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(input:
                                                        .init(weight: 135, reps: 8)))) // Add some inputs as well
        _ = await sut.interact(with: .addModifier(group: 1,
                                                  exerciseIndex: 0,
                                                  setIndex: 1,
                                                  modifier: .dropSet(input:
                                                        .repsWeight(input: .init(weight: 100))))) // Add to remove
        let result = await sut.interact(with: .removeModifier(group: 1, exerciseIndex: 0, setIndex: 1))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil),
            (.repsWeight(input: .init(weight: 135, reps: 8)), nil)
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [WorkoutFixtures.benchPress(inputs: benchSets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateModifier_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateModifier(group: 0,
                                                              exerciseIndex: 0,
                                                              setIndex: 0,
                                                              with: .repsOnly(input: .init(reps: 10))))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateModifier_FirstGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addModifier(group: 0,
                                                  exerciseIndex: 0,
                                                  setIndex: 0,
                                                  modifier: .restPause(input: .repsOnly(input: .init()))))
        let result = await sut.interact(with: .updateModifier(group: 0,
                                                              exerciseIndex: 0,
                                                              setIndex: 0,
                                                              with: .repsOnly(input: .init(reps: 8))))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()),
             .restPause(input: .repsOnly(input: .init(reps: 8))))
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: sets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.backSquatId))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: WorkoutFixtures.benchPressId))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(input:
                                                        .init(weight: 135, reps: 8)))) // Add some inputs as well
        _ = await sut.interact(with: .addModifier(group: 1,
                                                  exerciseIndex: 0,
                                                  setIndex: 1,
                                                  modifier: .dropSet(input:
                                                        .repsWeight(input: .init(weight: 100)))))
        let result = await sut.interact(with: .updateModifier(group: 1,
                                                              exerciseIndex: 0,
                                                              setIndex: 1,
                                                              with: .repsWeight(input: .init(weight: 100, reps: 5))))
        
        
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil)
        ]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(input: .init()), nil),
            (.repsWeight(input: .init(weight: 135, reps: 8)),
             .dropSet(input: .repsWeight(input: .init(weight: 100, reps: 5))))
        ]
        groupMap[0] = [WorkoutFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [WorkoutFixtures.benchPress(inputs: benchSets)]
        let groups = WorkoutFixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: true)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .filter(by: .favorite(isFavorite: true)))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_Filter_Search_Empty_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .filter(by: .search(searchText: "")))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: Fixtures.emptyFilterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_Search_NonEmpty_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .filter(by: .search(searchText: "back")))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let filterDomain = BuildWorkoutFilterDomain(searchText: "back",
                                                    isFavorite: false,
                                                    musclesWorked: Fixtures.musclesWorkedMap)
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_Search_NonEmpty_NoResults_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .filter(by: .search(searchText: "xyz")))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let filterDomain = BuildWorkoutFilterDomain(searchText: "xyz",
                                                    isFavorite: false,
                                                    musclesWorked: Fixtures.musclesWorkedMap)
        let expectedDomain = BuildWorkoutDomain(exercises: [:],
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_Favorite_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .filter(by: .favorite(isFavorite: true)))
        var result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.benchPressId))
        
        var exercises = [
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: true)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        var filterDomain = BuildWorkoutFilterDomain(searchText: "",
                                                    isFavorite: true,
                                                    musclesWorked: Fixtures.musclesWorkedMap)
        var expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        result = await sut.interact(with: .filter(by: .favorite(isFavorite: false))) // Cancel filter
        
        exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.benchPressId: Fixtures.benchPressAvailable(isSelected: false, isFavorite: true),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        filterDomain.isFavorite = false
        expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                            builtWorkout: workout,
                                            currentGroup: 0,
                                            filterDomain: filterDomain,
                                            canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_Favorite_NoResults_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .filter(by: .favorite(isFavorite: true)))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let filterDomain = BuildWorkoutFilterDomain(searchText: "",
                                                    isFavorite: true,
                                                    musclesWorked: Fixtures.musclesWorkedMap)
        let expectedDomain = BuildWorkoutDomain(exercises: [:],
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_MusclesWorked_Success() async {
        await loadExercises()
        var result = await sut.interact(with: .filter(by: .muscleWorked(muscle: .glutes, isSelected: true)))
        
        var exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        var musclesWorkoutMap = Fixtures.musclesWorkedMap
        musclesWorkoutMap[.glutes] = true
        var filterDomain = BuildWorkoutFilterDomain(searchText: "",
                                                    isFavorite: false,
                                                    musclesWorked: musclesWorkoutMap)
        var expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        result = await sut.interact(with: .filter(by: .muscleWorked(muscle: .back, isSelected: true)))
        
        exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false),
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        musclesWorkoutMap[.back] = true
        filterDomain.musclesWorked = musclesWorkoutMap
        expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                            builtWorkout: workout,
                                            currentGroup: 0,
                                            filterDomain: filterDomain,
                                            canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        result = await sut.interact(with: .filter(by: .muscleWorked(muscle: .glutes, isSelected: false)))
        
        exercises = [
            WorkoutFixtures.inclineRowId: Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        musclesWorkoutMap[.glutes] = false
        filterDomain.musclesWorked = musclesWorkoutMap
        expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                            builtWorkout: workout,
                                            currentGroup: 0,
                                            filterDomain: filterDomain,
                                            canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_MusclesWorked_NoResults_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .filter(by: .muscleWorked(muscle: .biceps, isSelected: true)))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        var musclesWorkoutMap = Fixtures.musclesWorkedMap
        musclesWorkoutMap[.biceps] = true
        let filterDomain = BuildWorkoutFilterDomain(searchText: "",
                                                    isFavorite: false,
                                                    musclesWorked: musclesWorkoutMap)
        let expectedDomain = BuildWorkoutDomain(exercises: [:],
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_Filter_MultipleFilters_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .filter(by: .favorite(isFavorite: true)))
        _ = await sut.interact(with: .filter(by: .search(searchText: "squat")))
        var result = await sut.interact(with: .filter(by: .muscleWorked(muscle: .quads, isSelected: true)))
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        var musclesWorkoutMap = Fixtures.musclesWorkedMap
        musclesWorkoutMap[.quads] = true
        let filterDomain = BuildWorkoutFilterDomain(searchText: "squat",
                                                    isFavorite: true,
                                                    musclesWorked: musclesWorkoutMap)
        var expectedDomain = BuildWorkoutDomain(exercises: [:],
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
        
        result = await sut.interact(with: .toggleFavorite(exerciseId: WorkoutFixtures.backSquatId))
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: true)
        ]
        expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                            builtWorkout: workout,
                                            currentGroup: 0,
                                            filterDomain: filterDomain,
                                            canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveAllFilters_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeAllFilters)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveAllFilters_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .filter(by: .favorite(isFavorite: true)))
        _ = await sut.interact(with: .filter(by: .search(searchText: "squat")))
        _ = await sut.interact(with: .filter(by: .muscleWorked(muscle: .quads, isSelected: true)))
        let result = await sut.interact(with: .removeAllFilters)
        
        let exercises = [
            WorkoutFixtures.backSquatId: Fixtures.backSquatAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                                           groupExercises: groupMap))
        let filterDomain = BuildWorkoutFilterDomain(searchText: "squat", // Search text kept
                                                    isFavorite: false,
                                                    musclesWorked: Fixtures.musclesWorkedMap)
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0,
                                                filterDomain: filterDomain,
                                                canSave: false)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
}

// MARK: - Private

private extension BuildWorkoutInteractorTests {
    @discardableResult
    func loadExercises() async -> BuildWorkoutDomainResult {
        return await sut.interact(with: .loadExercises)
    }
}
