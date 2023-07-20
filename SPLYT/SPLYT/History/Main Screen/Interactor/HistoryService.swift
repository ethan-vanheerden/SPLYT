//
//  HistoryService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/16/23.
//

import Foundation
import Caching
import ExerciseCore

// MARK: - Protocol

protocol HistoryServiceType {
    func loadWorkoutHistory() throws -> [WorkoutHistory]
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] // Returns the history with the workout deleted
}

// MARK: - Implementation

struct HistoryService: HistoryServiceType {
    private let cacheInteractor: CacheInteractorType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkoutHistory() throws -> [WorkoutHistory] {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        
        if !(try cacheInteractor.fileExists(request: completedWorkoutsRequest)) {
            try cacheInteractor.save(request: completedWorkoutsRequest,
                                     data: [WorkoutHistory]())
        }
        
        return try cacheInteractor.load(request: completedWorkoutsRequest)
    }
    
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        var workoutHistory = try loadWorkoutHistory()
        
        workoutHistory.removeAll { $0.id == historyId }
        try cacheInteractor.save(request: completedWorkoutsRequest, data: workoutHistory)
        
        return workoutHistory
    }
}

