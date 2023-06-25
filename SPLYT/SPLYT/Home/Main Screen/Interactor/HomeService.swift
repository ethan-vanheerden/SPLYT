//
//  HomeServiceType.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Caching
import ExerciseCore

// MARK: - Protocol

protocol HomeServiceType {
    func loadWorkouts() throws -> [String: CreatedWorkout]
    func saveWorkouts(_: [String: CreatedWorkout]) throws
    func deleteWorkoutHistory(filename: String) throws
}

// MARK: - Implementation

struct HomeService: HomeServiceType {
    private let cacheInteractor: CacheInteractorType
    private let workoutService: CreatedWorkoutsServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         workoutService: CreatedWorkoutsServiceType = CreatedWorkoutsService()) {
        self.cacheInteractor = cacheInteractor
        self.workoutService = workoutService
    }
    
    func loadWorkouts() throws -> [String: CreatedWorkout] {
        return try workoutService.loadWorkouts()
    }
    
    func saveWorkouts(_ workouts: [String: CreatedWorkout]) throws {
        try workoutService.saveWorkouts(workouts)
    }
    
    func deleteWorkoutHistory(filename: String) throws {
        let request = WorkoutHistoryCacheRequest(filename: filename)
        try cacheInteractor.deleteFile(request: request)
    }
}
