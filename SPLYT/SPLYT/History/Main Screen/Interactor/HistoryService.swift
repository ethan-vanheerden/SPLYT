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
    private let completedWorkoutsService: CompletedWorkoutsServiceType
    private let completedWorkoutsCacheRequest = CompletedWorkoutsCacheRequest()
    
    init(completedWorkoutsService: CompletedWorkoutsServiceType = CompletedWorkoutsService(),
         cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.completedWorkoutsService = completedWorkoutsService
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkoutHistory() throws -> [WorkoutHistory] {
        if !(try cacheInteractor.fileExists(request: completedWorkoutsCacheRequest)) {
            try cacheInteractor.save(request: completedWorkoutsCacheRequest,
                                     data: [WorkoutHistory]())
        }
        
        return try cacheInteractor.load(request: completedWorkoutsCacheRequest)
    }
    
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] {
        return try completedWorkoutsService.deleteWorkoutHistory(historyId: historyId)
    }
}

