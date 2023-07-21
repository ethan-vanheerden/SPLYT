//
//  WorkoutDetailsService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 7/20/23.
//

import Foundation
import Caching
import ExerciseCore

// MARK: - Protocol

protocol WorkoutDetailsServiceType {
    func loadWorkout(historyId: String) throws -> Workout
    func deleteWorkoutHistory(historyId: String) throws
}

// MARK: - Implementation

struct WorkoutDetailsService: WorkoutDetailsServiceType {
    private let cacheInteractor: CacheInteractorType
    private let completedWorkoutsService: CompletedWorkoutsServiceType
    private let completedWorkoutsCache = CompletedWorkoutsCacheRequest()
    
    init(completedWorkoutsService: CompletedWorkoutsServiceType = CompletedWorkoutsService(),
         cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.completedWorkoutsService = completedWorkoutsService
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkout(historyId: String) throws -> Workout {
        let histories = try cacheInteractor.load(request: completedWorkoutsCache)
        let history = histories.first { $0.id == historyId}
        
        guard let history = history else {
            throw WorkoutDetailsError.workoutNotFound
        }
        
        return history.workout
    }
    
    func deleteWorkoutHistory(historyId: String) throws {
        try completedWorkoutsService.deleteWorkoutHistory(historyId: historyId)
    }
}

// MARK: - Errors

enum WorkoutDetailsError: Error {
    case workoutNotFound
}
