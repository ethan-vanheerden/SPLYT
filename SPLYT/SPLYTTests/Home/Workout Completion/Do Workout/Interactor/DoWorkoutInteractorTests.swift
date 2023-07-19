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
                                       service: mockService)
    }
    
    func testInteract_LoadWorkout_ServiceError() async {
        mockService.loadWorkoutThrow = true
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
    
    func testInteract_UpdateSet_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: .repsWeight(input: .init(weight: 315, reps: 1)),
                                                         forModifier: false))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UpdateSet_NormalInput_Success() async {
        await loadWorkout()
        let updatedInput: SetInput = .repsWeight(input: .init(weight: 315, reps: 1))
        let result = await sut.interact(with: .updateSet(group: 0,
                                                         exerciseIndex: 0,
                                                         setIndex: 0,
                                                         with: updatedInput,
                                                         forModifier: false))
        
        var newSets = WorkoutFixtures.repsWeight4SetsPlaceholders
        newSets[0].0 = updatedInput
        
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
    
    func testInteract_UpdateSet_ModifierInput_Success() async {
        await loadWorkout()
        let updatedInput: SetInput = .repsWeight(input: .init(weight: 100, reps: 4))
        let result = await sut.interact(with: .updateSet(group: 1,
                                                         exerciseIndex: 0,
                                                         setIndex: 2,
                                                         with: updatedInput,
                                                         forModifier: true))
        
        var newSets = WorkoutFixtures.repsWeight3SetsPlaceholders
        newSets[2].1 = .dropSet(input: updatedInput)
        
        var newGroups = WorkoutFixtures.legWorkoutExercises_WorkoutStart
        newGroups[1].exercises = [WorkoutFixtures.barLunges(inputs: newSets)]
        
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
    
    func testInteract_UsePreviousInput_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .usePreviousInput(group: 0,
                                                                exerciseIndex: 0,
                                                                setIndex: 0,
                                                                forModifier: false))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_UsePreviousInput_NormalInput_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .usePreviousInput(group: 0,
                                                                exerciseIndex: 0,
                                                                setIndex: 0,
                                                                forModifier: false))
        
        // Should keep the placeholders
        let expectedInput: SetInput = .repsWeight(input: .init(weight: 135,
                                                               weightPlaceholder: 135,
                                                               reps: 12,
                                                               repsPlaceholder: 12))
        var newSets = WorkoutFixtures.repsWeight4SetsPlaceholders
        newSets[0].0 = expectedInput
        
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
    
    func testInteract_UsePreviousInput_ModifierInput_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .usePreviousInput(group: 1,
                                                                exerciseIndex: 0,
                                                                setIndex: 2,
                                                                forModifier: true))
        
        // Should keep the placeholders
        let expectedInput: SetInput = .repsWeight(input: .init(weight: 100,
                                                               weightPlaceholder: 100,
                                                               reps: 5,
                                                               repsPlaceholder: 5))
        var newSets = WorkoutFixtures.repsWeight3SetsPlaceholders
        newSets[2].1 = .dropSet(input: expectedInput)
        
        var newGroups = WorkoutFixtures.legWorkoutExercises_WorkoutStart
        newGroups[1].exercises = [WorkoutFixtures.barLunges(inputs: newSets)]
        
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
    
    func testInteract_ToggleDialog_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .toggleDialog(dialog: .finishWorkout, isOpen: true))
        XCTAssertEqual(result, .error)
    }
    
    func testInteract_ToggleDialog_FinishWorkout_Open_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .toggleDialog(dialog: .finishWorkout, isOpen: true))
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .dialog(dialog: .finishWorkout, domain: domain))
    }
    
    func testInteract_ToggleDialog_FinishWorkout_Close_Success() async {
        await loadWorkout()
        _ = await sut.interact(with: .toggleDialog(dialog: .finishWorkout, isOpen: true)) // Open so we can close
        let result = await sut.interact(with: .toggleDialog(dialog: .finishWorkout, isOpen: false))
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .loaded(domain))
    }
    
    func testInteract_SaveWorkout_NoSavedDomain_Error() async {
        let result = await sut.interact(with: .saveWorkout)
        XCTAssertEqual(result, .error)
        XCTAssertFalse(mockService.saveWorkoutCalled)
    }
    
    func testInteract_SaveWorkout_ServiceError() async {
        await loadWorkout()
        mockService.saveWorkoutThrow = true
        let result = await sut.interact(with: .saveWorkout)
        XCTAssertEqual(result, .error)
        XCTAssertTrue(mockService.saveWorkoutCalled)
    }
    
    func testInteract_SaveWorkout_Success() async {
        await loadWorkout()
        let result = await sut.interact(with: .saveWorkout)
        
        let domain = DoWorkoutDomain(workout: WorkoutFixtures.legWorkout_WorkoutStart,
                                     inCountdown: false,
                                     isResting: false,
                                     expandedGroups: [true, false],
                                     completedGroups: [false, false],
                                     fractionCompleted: 0)
        
        XCTAssertEqual(result, .exit(domain))
        XCTAssertTrue(mockService.saveWorkoutCalled)
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
