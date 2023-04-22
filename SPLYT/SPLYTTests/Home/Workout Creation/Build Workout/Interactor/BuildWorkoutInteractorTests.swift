//
//  BuildWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import XCTest
import ExerciseCore
@testable import SPLYT

final class BuildWorkoutInteractorTests: XCTestCase {
    typealias Fixtures = BuildWorkoutFixtures
    private var mockService: MockBuildWorkoutService!
    private var navState: NameWorkoutNavigationState!
    private var sut: BuildWorkoutInteractor!
    
    override func setUpWithError() throws {
        self.mockService = MockBuildWorkoutService()
        self.navState = NameWorkoutNavigationState(workoutName: "Test Workout")
        self.sut = BuildWorkoutInteractor(service: mockService,
                                          nameState: navState,
                                          creationDate: HomeFixtures.jan_1_2023_0800)
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
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
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
        let groups = Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
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
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_InvalidGroup_DoesNothing() async {
        await loadExercises()
        let result = await sut.interact(with: .removeGroup(group: 1)) // Not a group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_NotFirst_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup) // Add a group to remove
        let result = await sut.interact(with: .removeGroup(group: 1)) // Remove the added group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_First_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup) // Add a group to remove
        let result = await sut.interact(with: .removeGroup(group: 0)) // Remove the first group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveGroup_OnCurrentGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .switchGroup(to: 0)) // Go back to first group
        let result = await sut.interact(with: .removeGroup(group: 0)) // Remove our current group
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_IdNotString_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: 1, group: 0))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_ExerciseNoExist_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: "this-exercise-doesn't-exist", group: 0))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_InvalidGroup_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 1))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_AddExercise_OnlyExerciseInGroup_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_AddExercise_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // Add a starting exercise
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to the exercise
        let result = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: nil, weight: nil), nil),
                                                     count: 2)
        groupMap[0] = [
            HomeFixtures.backSquat(inputs: sets),
            HomeFixtures.benchPress(inputs: sets) // Added exercises has 2 sets as well
        ]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_RemoveExercise_OnlyExerciseInOneGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // First add the exercise
        let result = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // Removes it
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_RemoveExercise_LastExerciseInGroup_RemovesGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // First add the exercise
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 1)) // Add to new group
        let result = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // Now removes it
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: false, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        groupMap[0] = [
            HomeFixtures.benchPress(inputs: sets) // Now in group 0
        ]
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addSet(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddSet_OneExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        let result = await sut.interact(with: .addSet(group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: nil, weight: nil), nil),
                                                     count: 2)
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .addSet(group: 0)) // Add multiple sets
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: nil, weight: nil), nil),
                                                     count: 3)
        groupMap[0] = [
            HomeFixtures.backSquat(inputs: sets),
            HomeFixtures.benchPress(inputs: sets)
        ]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
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
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OnlyOneSetInGroup_DoesNothing() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(inputs: [(.repsWeight(reps: nil, weight: nil), nil)])]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OneExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to remove
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: nil, weight: nil), nil),
                                                     count: 2)
        groupMap[0] = [
            HomeFixtures.backSquat(inputs: sets),
            HomeFixtures.benchPress(inputs: sets)
        ]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: .repsWeight(reps: 12, weight: 135)))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateSet_FirstSet_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // One set automatically added
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: .repsWeight(reps: 12, weight: 135)))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: 12, weight: 135), nil)]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_NestedSet_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 1))
        _ = await sut.interact(with: .toggleExercise(exerciseId: "incline-db-row", group: 1))
        _ = await sut.interact(with: .addSet(group: 1))
        let result = await sut.interact(with: .updateSet(group: 1,
                                                         exerciseIndex: 1,
                                                         setIndex: 1,
                                                         with: .repsWeight(reps: 12, weight: 135)))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: true, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let group1Sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        let benchSets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: nil, weight: nil), nil),
                                                          count: 2)
        let rowSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(reps: nil, weight: nil), nil),
            (.repsWeight(reps: 12, weight: 135), nil)
        ]
        groupMap[0] = [HomeFixtures.backSquat(inputs: group1Sets)]
        groupMap[1] = [
            HomeFixtures.benchPress(inputs: benchSets),
            HomeFixtures.inclineDBRow(inputs: rowSets)
        ]
        let groups = Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateSet_AddedSetsAfterAlsoUpdated_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0)) // One set automatically added
        _ = await sut.interact(with: .updateSet(group: 0,
                                                exerciseIndex: 0,
                                                setIndex: 0,
                                                with: .repsWeight(reps: 12, weight: 135)))
        let result = await sut.interact(with: .addSet(group: 0)) // Added set should have updated input as well
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = Array(repeating: (.repsWeight(reps: 12, weight: 135), nil),
                                                     count: 2)
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleFavorite_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleFavorite(exerciseId: "back-squat"))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleFavorite_IdNotString_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleFavorite(exerciseId: 1))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleFavorite_ServiceError_Error() async {
        await loadExercises()
        mockService.saveExercisesThrow = true
        let result = await sut.interact(with: .toggleFavorite(exerciseId: "back-squat"))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveExercisesCalled)
    }
    
    func testInteract_ToggleFavorite_SelectFavorite_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleFavorite(exerciseId: "back-squat"))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: false, isFavorite: true),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleFavorite_DeselectFavorite_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleFavorite(exerciseId: "back-squat")) // Mark as favorite
        let result = await sut.interact(with: .toggleFavorite(exerciseId: "back-squat")) // Unmark as favorite
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
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
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
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
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .dialog(type: .save, domain: expectedDomain))
    }
    
    func testInteract_Save_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .save)
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
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
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .dialog(type: .leave, domain: expectedDomain))
    }
    
    func testInteract_ToggleDialog_OpenSave_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleDialog(type: .save, isOpen: true))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .dialog(type: .save, domain: expectedDomain))
    }
    
    func testInteract_ToggleDialog_Close_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleDialog(type: .leave, isOpen: true)) // Open dialog so we can close it
        let result = await sut.interact(with: .toggleDialog(type: .leave, isOpen: false))
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomain(exercises: Fixtures.loadedExercisesNoneSelectedMap,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
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
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        let result = await sut.interact(with: .addModifier(group: 0,
                                                           exerciseIndex: 0,
                                                           setIndex: 0,
                                                           modifier: .eccentric))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), .eccentric)]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 1))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(reps: 8, weight: 135))) // Add some inputs as well
        let result = await sut.interact(with: .addModifier(group: 1,
                                                           exerciseIndex: 0,
                                                           setIndex: 1,
                                                           modifier: .dropSet(input: .repsWeight(reps: nil,
                                                                                                 weight: 100))))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(reps: nil, weight: nil), nil),
            (.repsWeight(reps: 8, weight: 135), .dropSet(input: .repsWeight(reps: nil, weight: 100)))
        ]
        groupMap[0] = [HomeFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [HomeFixtures.benchPress(inputs: benchSets)]
        let groups = Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveModifier_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_RemoveModifier_FirstGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addModifier(group: 0,
                                                  exerciseIndex: 0,
                                                  setIndex: 0,
                                                  modifier: .eccentric)) // Add modifier to remove
        let result = await sut.interact(with: .removeModifier(group: 0, exerciseIndex: 0, setIndex: 0))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 1))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(reps: 8, weight: 135))) // Add some inputs as well
        _ = await sut.interact(with: .addModifier(group: 1,
                                                  exerciseIndex: 0,
                                                  setIndex: 1,
                                                  modifier: .dropSet(input: .repsWeight(reps: nil,
                                                                                        weight: 100)))) // Add to remove
        let result = await sut.interact(with: .removeModifier(group: 1, exerciseIndex: 0, setIndex: 1))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(reps: nil, weight: nil), nil),
            (.repsWeight(reps: 8, weight: 135), nil)
        ]
        groupMap[0] = [HomeFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [HomeFixtures.benchPress(inputs: benchSets)]
        let groups = Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateModifier_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateModifier(group: 0,
                                                              exerciseIndex: 0,
                                                              setIndex: 0,
                                                              with: .repsOnly(reps: 10)))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateModifier_FirstGroup_Success() async {
        await loadExercises()
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addModifier(group: 0,
                                                  exerciseIndex: 0,
                                                  setIndex: 0,
                                                  modifier: .restPause(input: .repsOnly(reps: nil))))
        let result = await sut.interact(with: .updateModifier(group: 0,
                                                              exerciseIndex: 0,
                                                              setIndex: 0,
                                                              with: .repsOnly(reps: 8)))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let sets: [(SetInput, SetModifier?)] = [
            (.repsWeight(reps: nil, weight: nil), .restPause(input: .repsOnly(reps: 8)))
        ]
        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_UpdateModifier_OtherGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
        _ = await sut.interact(with: .addGroup)
        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 1))
        _ = await sut.interact(with: .addSet(group: 1))
        _ = await sut.interact(with: .updateSet(group: 1,
                                                exerciseIndex: 0,
                                                setIndex: 1,
                                                with: .repsWeight(reps: 8, weight: 135))) // Add some inputs as well
        _ = await sut.interact(with: .addModifier(group: 1,
                                                  exerciseIndex: 0,
                                                  setIndex: 1,
                                                  modifier: .dropSet(input: .repsWeight(reps: nil,
                                                                                        weight: 100))))
        let result = await sut.interact(with: .updateModifier(group: 1,
                                                              exerciseIndex: 0,
                                                              setIndex: 1,
                                                              with: .repsWeight(reps: 5, weight: 100)))
        
        let exercises = [
            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        let squatSets: [(SetInput, SetModifier?)] = [(.repsWeight(reps: nil, weight: nil), nil)]
        let benchSets: [(SetInput, SetModifier?)] = [
            (.repsWeight(reps: nil, weight: nil), nil),
            (.repsWeight(reps: 8, weight: 135), .dropSet(input: .repsWeight(reps: 5, weight: 100)))
        ]
        groupMap[0] = [HomeFixtures.backSquat(inputs: squatSets)]
        groupMap[1] = [HomeFixtures.benchPress(inputs: benchSets)]
        let groups = Fixtures.exerciseGroups(numGroups: 2, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
                                                builtWorkout: workout,
                                                currentGroup: 1)
        
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
