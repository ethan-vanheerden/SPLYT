//
//  WorkoutReducerTests.swift
//  
//
//  Created by Ethan Van Heerden on 6/10/23.
//

import XCTest
@testable import DesignSystem
@testable import ExerciseCore

final class WorkoutReducerTests: XCTestCase {
    typealias Fixtures = WorkoutViewStateFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    private let sut = WorkoutReducer.self
    
    func testReduceExerciseGroups_HeaderLine() {
        [true, false].forEach {
            let result = sut.reduceExerciseGroups(groups: WorkoutFixtures.legWorkoutExercises,
                                                  includeHeaderLine: $0)
            XCTAssertEqual(result, Fixtures.legWorkoutExercises(includeHeaderLine: $0))
        }
    }
    
    func testGetGroupTitles() {
        let result = sut.getGroupTitles(workout: WorkoutFixtures.legWorkout)
        XCTAssertEqual(result, ["Group 1", "Group 2"])
    }
    
    func testGetNumExercisesTitle() {
        let workoutOneExercise = Workout(id: "One exercise",
                                         name: "One exercise",
                                         exerciseGroups: [
                                            ExerciseGroup(exercises: [WorkoutFixtures.backSquat(inputs: [])])
                                         ],
                                         createdAt: WorkoutFixtures.jan_1_2023_0800)
        
        
        let resultOne = sut.getNumExercisesTitle(workout: workoutOneExercise)
        let resultTwo = sut.getNumExercisesTitle(workout: WorkoutFixtures.legWorkout)
        let resultThree = sut.getNumExercisesTitle(workout: WorkoutFixtures.fullBodyWorkout)
        
        XCTAssertEqual(resultOne, "1 exercise")
        XCTAssertEqual(resultTwo, "2 exercises")
        XCTAssertEqual(resultThree, "4 exercises")
    }
    
    func testGetNumWorkoutsTitle() {
        let planOneWorkout = Plan(id: "One workout",
                                  name: "One Workout",
                                  workouts: [WorkoutFixtures.fullBodyWorkout],
                                  createdAt: WorkoutFixtures.jan_1_2023_0800)
        
        let resultOne = sut.getNumWorkoutsTitle(plan: planOneWorkout)
        let resultTwo = sut.getNumWorkoutsTitle(plan: WorkoutFixtures.myPlan)
        
        XCTAssertEqual(resultOne, "1 workout")
        XCTAssertEqual(resultTwo, "2 workouts")
    }
    
    func testCreateWorkoutRoutineTiles() {
        let workouts = [WorkoutFixtures.legWorkout, WorkoutFixtures.fullBodyWorkout]
        let result = sut.createWorkoutRoutineTiles(workouts: workouts)
        
        let expected = [Fixtures.doLegWorkoutRoutineTile, Fixtures.doFullBodyWorkoutRoutineTile]
        
        XCTAssertEqual(result, expected)
    }
    
    func testGetLastCompletedTitle() {
        let resultOne = sut.getLastCompletedTitle(date: WorkoutFixtures.dec_27_2022_1000)
        let resultTwo = sut.getLastCompletedTitle(date: WorkoutFixtures.feb_3_2023_1630)
        let resultThree = sut.getLastCompletedTitle(date: WorkoutFixtures.jan_1_2023_0800)
        
        XCTAssertEqual(resultOne, "Last completed: Dec 27, 2022")
        XCTAssertEqual(resultTwo, "Last completed: Feb 3, 2023")
        XCTAssertEqual(resultThree, "Last completed: Jan 1, 2023")
    }
}
