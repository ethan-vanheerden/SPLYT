//
//  DoWorkoutInteractorTests.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/11/23.
//

import XCTest
@testable import SPLYT
@testable import ExerciseCore

final class DoWorkoutInteractorTests: XCTestCase {
    typealias WorkoutFixtures = WorkoutModelFixtures
    private var mockService: MockDoWorkoutService!
    private var sut: DoWorkoutInteractor!
    
    override func setUpWithError() throws {
        self.mockService = MockDoWorkoutService()
        self.sut = DoWorkoutInteractor(workoutId: WorkoutFixtures.legWorkoutId,
                                       filename: WorkoutFixtures.legWorkoutFilename,
                                       service: mockService)
    }
    
    func testInteract_LoadWorkout_ServiceError() async {
        mockService.loadThrow = true
        let result = await sut.interact(with: .loadWorkout)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_LoadWorkout_Success() async {
        let result = await sut.interact(with: .loadWorkout)
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: true,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_StopCoundown_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .stopCountdown)
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_StopCountdown_Success() async {
        _ = await sut.interact(with: .loadWorkout)
        let result = await sut.interact(with: .stopCountdown)
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_ToggleRest_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleRest(isResting: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleRest_Success() async {
        await loadWorkout()
        // Start rest
        var result = await sut.interact(with: .toggleRest(isResting: true))
        
        var domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: true,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
        
        // Stop rest
        result = await sut.interact(with: .toggleRest(isResting: false))
        
        domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                 inCountdown: false,
                                 isResting: false,
                                 expandedGroups: [true, false],
                                 completedGroups: [false, false],
                                 fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_ToggleGroupExpand_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleGroupExpand(group: 1, isExpanded: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleGroupExpand_Success() async {
        await loadWorkout()
        // Expand
        var result = await sut.interact(with: .toggleGroupExpand(group: 1, isExpanded: true))
        
        var domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, true],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
        
        // Collapse
        result = await sut.interact(with: .toggleGroupExpand(group: 1, isExpanded: false))
        
        domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                 inCountdown: false,
                                 isResting: false,
                                 expandedGroups: [true, false],
                                 completedGroups: [false, false],
                                 fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_CompleteGroup_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .completeGroup(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_CompleteGroup_NextGroupNotComplete_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .completeGroup(group: 0))
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [false, true],
                                     completedGroups: [true, false],
                                     fractionCompleted: 0.5)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_CompleteGroup_WrapAroundExpand_Success() async {
        await loadWorkout()
        _ = await sut.interact(with: .toggleGroupExpand(group: 0, isExpanded: false)) // Collapse group to see if it opens
        let result = await sut.interact(with: .completeGroup(group: 1))
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, true],
                                     fractionCompleted: 0.5)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_AddSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .addSet(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_AddSet_SingleSet_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .addSet(group: 0))
        
        let addedSet: SetInput = .repsWeight(input: .init(weightPlaceholder: 225,
                                                          repsPlaceholder: 2))
        var newSets = WorkoutFixtures.repsWeight4SetsPlaceholders
        newSets.append((addedSet, nil))
        
        var newGroups = WorkoutFixtures.legWorkoutExercises_WorkoutStart
        newGroups[0].exercises = [WorkoutFixtures.backSquat(inputs: newSets)]
        
        var workout = WorkoutFixtures.legWorkout_WorkoutStart
        workout.exerciseGroups = newGroups
        
        let domain = DoWorkoutDomain(workout: workout,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_AddSet_Superset_Success() async {
        mockService.stubWorkout = WorkoutFixtures.fullBodyWorkout
        await loadWorkout()
        let result = await sut.interact(with: .addSet(group: 1))
        
        
        // Both sets happen to have same input
        let addedSet: SetInput = .repsWeight(input: .init(weightPlaceholder: 155,
                                                          repsPlaceholder: 8))
        var newSets = WorkoutFixtures.repsWeight3SetsPlaceholders
        newSets.append((addedSet, nil))
        
        var newGroups = WorkoutFixtures.fullBodyWorkoutExercises_WorkoutStart
        newGroups[1].exercises = [
            WorkoutFixtures.barLunges(inputs: newSets),
            WorkoutFixtures.inclineDBRow(inputs: newSets)
        ]
        
        var workout = WorkoutFixtures.fullBodyWorkout_WorkoutStart
        workout.exerciseGroups = newGroups
        
        let domain = DoWorkoutDomain(workout: workout,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_RemoveSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .removeSet(group: 0))
        XCTAssertEqual(result, .error)
    }
    
    func testRemoveSet_SingleSet_OnlyOneSetInGroup_DoesNothing() async {
        // Make a workout where a group has only one set
        let set = WorkoutFixtures.repsWeight4Sets[0]
        let groups = [
            ExerciseGroup(exercises: [
                WorkoutFixtures.backSquat(inputs: [set])
            ])
        ]
        var workout = WorkoutFixtures.legWorkout
        workout.exerciseGroups = groups
        
        mockService.stubWorkout = workout
        await loadWorkout()
        let result = await sut.interact(with: .removeSet(group: 0))
        
        let newGroups: [Int: [Exercise]] = [
            0: [WorkoutFixtures.backSquat(inputs: [WorkoutFixtures.repsWeight4SetsPlaceholders[0]])]
        ]
        
        workout.exerciseGroups = WorkoutFixtures.exerciseGroups(numGroups: 1,
                                                                groupExercises: newGroups)
        
        let domain = DoWorkoutDomain(workout: workout,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true],
                                     completedGroups: [false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testRemoveSet_SingleSet_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .removeSet(group: 0))
        
        var newSets = WorkoutFixtures.repsWeight4SetsPlaceholders
        newSets.removeLast()
        
        var newGroups = WorkoutFixtures.legWorkoutExercises_WorkoutStart
        newGroups[0].exercises = [WorkoutFixtures.backSquat(inputs: newSets)]
        
        var workout = WorkoutFixtures.legWorkout_WorkoutStart
        workout.exerciseGroups = newGroups
        
        let domain = DoWorkoutDomain(workout: workout,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testRemoveSet_Superset_Success() async {
        mockService.stubWorkout = WorkoutFixtures.fullBodyWorkout
        await loadWorkout()
        let result = await sut.interact(with: .removeSet(group: 1))
        
        // Both sets happen to have same input
        var newSets = WorkoutFixtures.repsWeight3SetsPlaceholders
        newSets.removeLast()
        
        var newGroups = WorkoutFixtures.fullBodyWorkoutExercises_WorkoutStart
        newGroups[1].exercises = [
            WorkoutFixtures.barLunges(inputs: newSets),
            WorkoutFixtures.inclineDBRow(inputs: newSets)
        ]
        
        var workout = WorkoutFixtures.fullBodyWorkout_WorkoutStart
        workout.exerciseGroups = newGroups
        
        let domain = DoWorkoutDomain(workout: workout,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    
}

// MARK: - Private

private extension DoWorkoutInteractorTests {
    @discardableResult
    func loadWorkout() async -> DoWorkoutDomainResult {
        _ = await sut.interact(with: .loadWorkout)
        return await sut.interact(with: .stopCountdown) // Simulates actual use
    }
}
