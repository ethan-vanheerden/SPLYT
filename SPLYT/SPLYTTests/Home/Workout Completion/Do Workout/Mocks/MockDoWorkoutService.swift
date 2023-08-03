//
//  MockDoWorkoutService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 6/11/23.
//

import Foundation
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class MockDoWorkoutService: DoWorkoutServiceType {
    typealias Fixtures = DoWorkoutFixtures
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var loadWorkoutThrow = false
    var stubWorkout: Workout? = nil
    func loadWorkout(workoutId: String, planId: String?) throws -> Workout {
        guard !loadWorkoutThrow else { throw MockError.someError }
        return stubWorkout ?? WorkoutFixtures.legWorkout
    }
    
    var saveWorkoutThrow = false
    private(set) var saveWorkoutCalled = false
    func saveWorkout(workout: Workout, planId: String?, completionDate: Date) throws {
        saveWorkoutCalled = true
        guard !saveWorkoutThrow else { throw MockError.someError }
    }
    
    func loadRestPresets() -> [Int] {
        return Fixtures.restPresets
    }
}
