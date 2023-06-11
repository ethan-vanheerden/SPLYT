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
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var loadThrow = false
    var stubWorkout: Workout? = nil
    func loadWorkout(filename: String, workoutId: String) throws -> Workout {
        guard !loadThrow else { throw MockError.someError }
        return stubWorkout ?? WorkoutFixtures.legWorkout
    }
    
    var saveThrow = false
    private(set) var saveCalled = false
    func saveWorkout(workout: Workout, filename: String) throws {
        guard !saveThrow else { throw MockError.someError }
        saveCalled = true
    }
}
