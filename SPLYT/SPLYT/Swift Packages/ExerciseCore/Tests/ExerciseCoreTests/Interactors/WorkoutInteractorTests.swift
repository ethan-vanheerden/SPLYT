//
//  WorkoutInteractorTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/9/23.
//

import XCTest
@testable import ExerciseCore

final class WorkoutInteractorTests: XCTestCase {
    typealias Fixtures = WorkoutModelFixtures
    private let sut = WorkoutInteractor.self
    
    func testAddSet_SingleSet_NoExercises_DoesNothing() {
        let groups = [ExerciseGroup(exercises: [])]
        let result = sut.addSet(group: 0, groups: groups)
        
        XCTAssertEqual(result, groups)
    }
    
    func testAddSet_SingleSet() {
        let result = sut.addSet(group: 0, groups: Fixtures.legWorkoutExercises)
        
        let addedSet: SetInput = .repsWeight(input: .init(weight: 225, reps: 2, repsPlaceholder: 0))
        var newSets = Fixtures.repsWeight4Sets
        newSets.append((addedSet, nil))
        
        var newGroups = Fixtures.legWorkoutExercises
        newGroups[0].exercises = [Fixtures.backSquat(inputs: newSets)]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testAddSet_Superset() {
        let result = sut.addSet(group: 1, groups: Fixtures.fullBodyWorkoutExercises)
        
        // Both sets happen to have same input
        let addedSet: SetInput = .repsWeight(input: .init(weight: 155, reps: 8))
        var newSets = Fixtures.repsWeight3Sets
        newSets.append((addedSet, nil))
        
        var newGroups = Fixtures.fullBodyWorkoutExercises
        newGroups[1].exercises = [
            Fixtures.barLunges(inputs: newSets),
            Fixtures.inclineDBRow(inputs: newSets)
        ]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testRemoveSet_SingleSet_NoExercises_DoesNothing() {
        let groups = [ExerciseGroup(exercises: [])]
        let result = sut.removeSet(group: 0, groups: groups)
        
        XCTAssertEqual(result, groups)
    }
    
    func testRemoveSet_SingleSet_OnlyOneSetInGroup_DoesNothing() {
        let set = Fixtures.repsWeight3Sets[0]
        let groups = [
            ExerciseGroup(exercises: [
                Fixtures.backSquat(inputs: [set])
            ])
        ]
        let result = sut.removeSet(group: 0, groups: groups)
        
        XCTAssertEqual(result, groups)
    }
    
    func testRemoveSet_SingleSet() {
        let result = sut.removeSet(group: 0, groups: Fixtures.legWorkoutExercises)
        
        var newSets = Fixtures.repsWeight4Sets
        newSets.removeLast()
        
        var newGroups = Fixtures.legWorkoutExercises
        newGroups[0].exercises = [Fixtures.backSquat(inputs: newSets)]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testRemoveSet_Superset() {
        let result = sut.removeSet(group: 1, groups: Fixtures.fullBodyWorkoutExercises)
        
        // Both sets happen to have same input
        var newSets = Fixtures.repsWeight3Sets
        newSets.removeLast()
        
        var newGroups = Fixtures.fullBodyWorkoutExercises
        newGroups[1].exercises = [
            Fixtures.barLunges(inputs: newSets),
            Fixtures.inclineDBRow(inputs: newSets)
        ]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testUpdateSet() {
        let updatedInput: SetInput = .repsWeight(input: .init(weight: 225, reps: 10))
        let updatedModifierInput: SetInput = .repsWeight(input: .init(weight: 100, weightPlaceholder: 80, reps: 10))
        let updatedSetIndex = 2 // Update the last set
        let result = sut.updateSet(groupIndex: 1,
                                   groups: Fixtures.legWorkoutExercises,
                                   exerciseIndex: 0,
                                   setIndex: updatedSetIndex,
                                   newSetInput: updatedInput,
                                   newModifierInput: updatedModifierInput)
        
        var newSets = Fixtures.repsWeight3Sets
        newSets[updatedSetIndex] = (updatedInput, .dropSet(input: updatedModifierInput))
        
        var newGroups = Fixtures.legWorkoutExercises
        newGroups[1].exercises = [Fixtures.barLunges(inputs: newSets)]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testEditModifier_AddModifier() {
        let newModifier: SetModifier = .restPause(input: .repsOnly(input: .init(reps: 5, placeholder: 0)))
        let updatedSetIndex = 3
        let result = sut.editModifier(groupIndex: 0,
                                      groups: Fixtures.legWorkoutExercises,
                                      exerciseIndex: 0,
                                      setIndex: updatedSetIndex,
                                      modifier: newModifier)
        
        var newSets = Fixtures.repsWeight4Sets
        newSets[updatedSetIndex] = (newSets[updatedSetIndex].0, newModifier)
        
        var newGroups = Fixtures.legWorkoutExercises
        newGroups[0].exercises = [Fixtures.backSquat(inputs: newSets)]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testEditModifier_RemoveModifier() {
        let updatedSetIndex = 2
        let result = sut.editModifier(groupIndex: 1,
                                      groups: Fixtures.legWorkoutExercises,
                                      exerciseIndex: 0,
                                      setIndex: updatedSetIndex,
                                      modifier: nil)
        
        var newSets = Fixtures.repsWeight3Sets
        newSets[updatedSetIndex] = (newSets[updatedSetIndex].0, nil)
        
        var newGroups = Fixtures.legWorkoutExercises
        newGroups[1].exercises = [Fixtures.barLunges(inputs: newSets)]
        
        XCTAssertEqual(result, newGroups)
    }
    
    func testGetId() {
        let result = sut.getId(name: Fixtures.myPlanName,
                               creationDate: Fixtures.jan_1_2023_0800)
        XCTAssertEqual(result, Fixtures.myPlanId)
    }
}
