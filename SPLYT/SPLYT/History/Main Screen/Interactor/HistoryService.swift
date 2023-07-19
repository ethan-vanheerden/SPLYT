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
    func loadWorkoutHistory() throws -> [Workout]
    func deleteWorkoutHistory(workoutId: String,
                              completionDate: Date) throws -> [Workout] // Returns the history with the workout deleted
}

// MARK: - Implementation

struct HistoryService: HistoryServiceType {
    private let cacheInteractor: CacheInteractorType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkoutHistory() throws -> [Workout] {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        
        if !(try cacheInteractor.fileExists(request: completedWorkoutsRequest)) {
            try cacheInteractor.save(request: completedWorkoutsRequest,
                                     data: [Workout]())
        }
        
        return try cacheInteractor.load(request: completedWorkoutsRequest)
    }
    
    func deleteWorkoutHistory(workoutId: String, completionDate: Date) throws -> [Workout] {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        var workoutHistory = try loadWorkoutHistory()
        
        workoutHistory.removeAll { $0.id == workoutId && $0.lastCompleted == completionDate }
        try cacheInteractor.save(request: completedWorkoutsRequest, data: workoutHistory)
        
        return workoutHistory
    }
}

