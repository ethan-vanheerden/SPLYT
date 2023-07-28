//
//  MockWorkoutDetailsService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/28/23.
//

import Foundation
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class MockWorkoutDetailsService: WorkoutDetailsServiceType {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var loadWorkoutThrow = false
    private(set) var loadWorkoutCalled = false
    func loadWorkout(historyId: String) throws -> Workout {
        loadWorkoutCalled = true
        if loadWorkoutThrow { throw MockError.someError }
        
        let histories = WorkoutFixtures.workoutHistories
        
        guard let history =  histories.first(where: { $0.id == historyId }) else {
            throw MockError.someError
        }
        
        return history.workout
    }
    
    var deleteWorkoutHistoryThrow = false
    private(set) var deleteWorkoutHistoryCalled = false
    func deleteWorkoutHistory(historyId: String) throws {
        deleteWorkoutHistoryCalled = true
        if deleteWorkoutHistoryThrow { throw MockError.someError }
    }
}
