//
//  MockHomeService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/7/23.
//

import Foundation
@testable import SPLYT
import Mocking
@testable import ExerciseCore

final class MockHomeService: HomeServiceType {
    typealias Fixtures = WorkoutModelFixtures
    
    var loadWorkoutsThrow = false
    func loadWorkouts() throws -> [String: CreatedWorkout] {
        if loadWorkoutsThrow { throw MockError.someError }
        return Fixtures.loadedCreatedWorkouts
    }
    
    var saveWorkoutsThrow = false
    private(set) var saveWorkoutsCalled = false
    func saveWorkouts(_: [String: CreatedWorkout]) throws {
        saveWorkoutsCalled = true
        if saveWorkoutsThrow { throw MockError.someError }
    }
}
