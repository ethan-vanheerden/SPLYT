//
//  MockBuildWorkoutService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import Foundation
@testable import SPLYT
import Mocking

final class MockBuildWorkoutService: BuildWorkoutServiceType {
    typealias Fixtures = BuildWorkoutFixtures
    
    var loadExercisesThrow = false
    func loadAvailableExercises() throws -> [String: AvailableExercise] {
        if loadExercisesThrow { throw MockError.someError }
        return Fixtures.loadedExercisesNoneSelectedMap
    }
    
    private(set) var saveExercisesCalled = false
    var saveExercisesThrow = false
    func saveAvailableExercises(_: [AvailableExercise]) throws {
        saveExercisesCalled = true
        if saveExercisesThrow { throw MockError.someError }
    }
    
    private(set) var saveWorkoutCalled = false
    var saveWorkoutThrow = false
    func saveWorkout(_: SPLYT.Workout) throws {
        saveWorkoutCalled = true
        if saveWorkoutThrow { throw MockError.someError }
    }
}
