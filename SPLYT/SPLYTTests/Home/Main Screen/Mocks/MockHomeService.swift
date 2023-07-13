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
    
    var loadRoutinesThrow = false
    func loadRoutines() throws -> CreatedRoutines {
        if loadRoutinesThrow { throw MockError.someError }
        return Fixtures.loadedRoutines
    }
    
    var saveRoutinesThrow = false
    private(set) var saveRoutinesCalled = false
    func saveRoutines(_: CreatedRoutines) throws {
        saveRoutinesCalled = true
        if saveRoutinesThrow { throw MockError.someError }
    }
    
    var deleteWorkoutHistoryThrow = false
    private(set) var deleteWorkoutHistoryCalled = false
    func deleteWorkoutHistory(historyFilename: String) throws {
        deleteWorkoutHistoryCalled = true
        if deleteWorkoutHistoryThrow { throw MockError.someError }
    }
}
