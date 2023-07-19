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
}

// MARK: - Implementation

struct HistoryService: HistoryServiceType {
    private let cacheInteractor: CacheInteractorType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkoutHistory() throws -> [Workout] {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        return try cacheInteractor.load(request: completedWorkoutsRequest)
    }
}

