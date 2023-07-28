//
//  MockCompletedWorkoutsService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/21/23.
//

import Foundation
@testable import ExerciseCore
import Mocking

final class MockCompletedWorkoutsService: CompletedWorkoutsServiceType {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var deleteHistoryThrow = false
    private(set) var deleteHistoryCalled = false
    @discardableResult
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] {
        deleteHistoryCalled = true
        if deleteHistoryThrow { throw MockError.someError }
        return [WorkoutFixtures.fullBodyWorkout_WorkoutHistory]
    }
}
