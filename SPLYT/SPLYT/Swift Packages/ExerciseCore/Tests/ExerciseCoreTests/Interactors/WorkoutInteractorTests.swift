//
//  WorkoutInteractorTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/9/23.
//

import XCTest
@testable import ExerciseCore

final class WorkoutInteractorTests: XCTestCase {
    private let sut = WorkoutInteractor.self
    
//    func testInteract_AddSet_OneExerciseInGroup() async {
//
//        let result = sut.addSet(group: 0, groups: <#T##[ExerciseGroup]#>)
//
//        var groupMap = [Int: [Exercise]]()
//        let sets: [(SetInput, SetModifier?)] = Array(
//            repeating: (.repsWeight(input: .init()), nil),
//            count: 2
//        )
//        groupMap[0] = [HomeFixtures.backSquat(inputs: sets)]
//        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
//        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
//        
//        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
//                                                builtWorkout: workout,
//                                                currentGroup: 0)
//        
//        XCTAssertEqual(result, .loaded(expectedDomain))
//    }
//    
//    func testInteract_AddSet_MultipleExercisesInGroup() async {
//        await loadExercises()
//        _ = await sut.interact(with: .toggleExercise(exerciseId: "back-squat", group: 0))
//        _ = await sut.interact(with: .toggleExercise(exerciseId: "bench-press", group: 0))
//        _ = await sut.interact(with: .addSet(group: 0))
//        let result = await sut.interact(with: .addSet(group: 0)) // Add multiple sets
//        
//        let exercises = [
//            "back-squat": Fixtures.backSquatAvailable(isSelected: true, isFavorite: false),
//            "bench-press": Fixtures.benchPressAvailable(isSelected: true, isFavorite: false),
//            "incline-db-row": Fixtures.inclineDBRowAvailable(isSelected: false, isFavorite: false)
//        ]
//        var groupMap = [Int: [Exercise]]()
//        let sets: [(SetInput, SetModifier?)] = Array(
//            repeating: (.repsWeight(input: .init()), nil),
//            count: 3
//        )
//        groupMap[0] = [
//            HomeFixtures.backSquat(inputs: sets),
//            HomeFixtures.benchPress(inputs: sets)
//        ]
//        let groups = Fixtures.exerciseGroups(numGroups: 1, groupExercises: groupMap)
//        let workout = Fixtures.builtWorkout(exerciseGroups: groups)
//        
//        let expectedDomain = BuildWorkoutDomain(exercises: exercises,
//                                                builtWorkout: workout,
//                                                currentGroup: 0)
//        
//        XCTAssertEqual(result, .loaded(expectedDomain))
//    }
}
