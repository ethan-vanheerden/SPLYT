//
//  MockHomeService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 3/7/23.
//

import Foundation
@testable import SPLYT
import Mocking

final class MockHomeService: HomeServiceType {
    typealias Fixtures = HomeFixtures
    
    var loadWorkoutsThrow = false
    func loadWorkouts() throws -> [SPLYT.Workout] {
        if loadWorkoutsThrow { throw MockError.someError }
        return Fixtures.loadedWorkouts
    }
    
    var saveWorkoutsThrow = false
    private(set) var saveWorkoutsCalled = false
    func saveWorkouts(_: [SPLYT.Workout]) throws {
        saveWorkoutsCalled = true
        if saveWorkoutsThrow { throw MockError.someError }
    }
}
