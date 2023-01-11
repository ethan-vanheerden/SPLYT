//
//  MockBuildWorkoutService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import Foundation
@testable import SPLYT

final class MockBuildWorkoutService: BuildWorkoutServiceType {
    typealias Fixtures = BuildWorkoutFixtures
    var shouldThrow = false
    
    func loadAvailableExercises() throws -> [AvailableExercise] {
        if shouldThrow { throw MockBuildWorkoutServiceError.someError }
        return Fixtures.loadedExercisesNoneSelected
    }
    
    var saveCalled = false
    func saveAvailableExercises(_: [AvailableExercise]) throws {
        saveCalled = true
        if shouldThrow { throw MockBuildWorkoutServiceError.someError }
    }
}

enum MockBuildWorkoutServiceError: Error {
    case someError
}
