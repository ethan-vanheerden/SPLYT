//
//  MockHistoryService.swift
//  SPLYTTests
//
//  Created by Ethan Van Heerden on 7/21/23.
//

import Foundation
@testable import SPLYT
@testable import ExerciseCore
import Mocking

final class MockHistoryService: HistoryServiceType {
    typealias WorkoutFixtures = WorkoutModelFixtures
    
    var loadHistoryThrow = false
    private(set) var loadHistoryCalled = false
    func loadWorkoutHistory() throws -> [WorkoutHistory] {
        loadHistoryCalled = true
        if loadHistoryThrow { throw MockError.someError }
        
        return WorkoutFixtures.workoutHistories
    }
    
    var deleteHistoryThrow = false
    private(set) var deleteHistoryCalled = false
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] {
        deleteHistoryCalled = true
        if deleteHistoryThrow { throw MockError.someError }
        
        var histories = try loadWorkoutHistory()
        histories.removeAll { $0.id == historyId }
        return histories
    }
}
