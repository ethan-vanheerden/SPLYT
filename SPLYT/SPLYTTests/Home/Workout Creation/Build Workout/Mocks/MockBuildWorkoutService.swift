//
//  MockBuildWorkoutService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 2/1/23.
//

import Foundation
@testable import SPLYT
import Mocking
import ExerciseCore

final class MockBuildWorkoutService: BuildWorkoutServiceType {
    typealias Fixtures = BuildWorkoutFixtures
    
    var loadExercisesThrow = false
    func loadAvailableExercises() async throws -> [String: AvailableExercise] {
        if loadExercisesThrow { throw MockError.someError }
        return Fixtures.loadedExercisesNoneSelectedMap
    }
    
    private(set) var toggleFavoriteCalled = false
    var toggleFavoriteThrow = false
    func toggleFavorite(exerciseId: String, isFavorite: Bool) async throws {
        toggleFavoriteCalled = true
        if toggleFavoriteThrow { throw MockError.someError }
    }
    
    private(set) var saveWorkoutCalled = false
    var saveWorkoutThrow = false
    func saveWorkout(_: Workout) throws {
        saveWorkoutCalled = true
        if saveWorkoutThrow { throw MockError.someError }
    }
}
