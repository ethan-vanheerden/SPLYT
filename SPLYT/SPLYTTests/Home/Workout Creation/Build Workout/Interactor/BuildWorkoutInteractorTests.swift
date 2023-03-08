//
//  BuildWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import XCTest
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_IdNotString_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(id: 1, group: 0))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_ExerciseNoExist_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(id: "this-exercise-doesn't-exist", group: 0))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_InvalidGroup_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(id: "back-squat", group: 1))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleExercise_AddExercise_OnlyExerciseInGroup_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 1)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_RemoveExercise_OnlyExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0)) // First add the exercise
        let result = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0)) // Removes it
        
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let workout = Fixtures.builtWorkout(exerciseGroups: Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap))
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleExercise_AddExercise_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0)) // Add a starting exercise
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to the exercise
        let result = await sut.interact(with: .toggleExercise(id: "bench-press", group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 2), HomeFixtures.benchPress(numSets: 2)] // Added exercises has 2 sets as well
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
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
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        let result = await sut.interact(with: .addSet(group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 2)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_AddSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        _ = await sut.interact(with: .toggleExercise(id: "bench-press", group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .addSet(group: 0)) // Add multiple sets
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 3), HomeFixtures.benchPress(numSets: 3)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
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
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OnlyOneSetInGroup_DoesNothing() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 1)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_OneExerciseInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        _ = await sut.interact(with: .addSet(group: 0)) // Add a set to remove
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 1)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_RemoveSet_MultipleExercisesInGroup_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleExercise(id: "back-squat", group: 0))
        _ = await sut.interact(with: .toggleExercise(id: "bench-press", group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        _ = await sut.interact(with: .addSet(group: 0))
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
            Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = [HomeFixtures.backSquat(numSets: 2), HomeFixtures.benchPress(numSets: 2)]
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    // TODO: SPLYT-31: updateSet tests
    
    func testInteract_ToggleFavorite_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleFavorite(id: "back-squat"))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleFavorite_IdNotString_Error() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleFavorite(id: 1))
        
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleFavorite_ServiceError_Error() async {
        await loadExercises()
        mockService.saveExercisesThrow = true
        let result = await sut.interact(with: .toggleFavorite(id: "back-squat"))
        
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveExercisesCalled)
    }
    
    func testInteract_ToggleFavorite_SelectFavorite_Success() async {
        await loadExercises()
        let result = await sut.interact(with: .toggleFavorite(id: "back-squat"))
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: false, isFavorite: true), // Marked as favorite
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
        XCTAssertEqual(result, .loaded(expectedDomain))
    }
    
    func testInteract_ToggleFavorite_DeselectFavorite_Success() async {
        await loadExercises()
        _ = await sut.interact(with: .toggleFavorite(id: "back-squat")) // Mark as favorite
        let result = await sut.interact(with: .toggleFavorite(id: "back-squat")) // Unmark as favorite
        
        let exercises = [
            Fixtures.backSquatAvailable(isSelected: false, isFavorite: false), // Not a favorite
            Fixtures.benchPressAvailable(isSelected: false, isFavorite: false),
            Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
        ]
        var groupMap = [Int: [Exercise]]()
        groupMap[0] = []
        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
        
        let expectedDomain = BuildWorkoutDomainObject(exercises: exercises,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
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
        let expectedDomain = BuildWorkoutDomainObject(exercises: Fixtures.loadedExercisesNoneSelected,
                                                      builtWorkout: workout,
                                                      currentGroup: 0)
        
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
