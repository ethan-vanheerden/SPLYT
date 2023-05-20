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

struct DoWorkoutService<T: CacheInteractorType>: DoWorkoutServiceType where T.Request == CreatedWorkoutsCacheRequest {
    private let workoutCacheInteractor: T
    
    init(workoutCacheInteractor: T = CacheInteractor(request: CreatedWorkoutsCacheRequest())) {
        self.workoutCacheInteractor = workoutCacheInteractor
    }
    
    func loadWorkout(id: String) throws -> Workout {
        let workoutDict = try workoutCacheInteractor.load()
        guard let workout = workoutDict[id] else {
            throw DoWorkoutError.workoutNoExist
        }
        return workout
    }
}
