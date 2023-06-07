//
//  DoWorkoutService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Caching
import ExerciseCore

// MARK: - Protocol

protocol DoWorkoutServiceType {
    func loadWorkout(id: String) throws -> Workout
}

// MARK: - Errors

enum DoWorkoutError: Error {
    case workoutNoExist
}

// MARK: - Implementation

struct DoWorkoutService<T: CacheInteractorType>: DoWorkoutServiceType where T.Request == WorkoutHistoryCacheRequest {
    private let workoutCacheInteractor: T
    
    init(cache: T.Request) {
        self.workoutCacheInteractor = CacheInteractor(request: cache)
    }
    
    func loadWorkout(id: String) throws -> Workout {
        let workoutDict = try workoutCacheInteractor.load()
        // The first workout in this list will be the most recent one
        guard let workout = workoutDict.first else {
            throw DoWorkoutError.workoutNoExist
        }
        return workout
    }
}
