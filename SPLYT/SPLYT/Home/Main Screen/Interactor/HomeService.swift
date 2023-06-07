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
    func loadWorkouts() throws -> [CreatedWorkout]
    func saveWorkouts(_: [CreatedWorkout]) throws
}

// MARK: - Implementation

struct HomeService<T: CacheInteractorType>: HomeServiceType where T.Request == CreatedWorkoutsCacheRequest {
    private let cacheInteractor: T
    
    init(cacheInteractor: T = CacheInteractor(request: CreatedWorkoutsCacheRequest())) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkouts() throws -> [CreatedWorkout] {
        // First check if they have any saved workouts yet
        if !(try cacheInteractor.fileExists()) {
            // Create the file by saving an empty list of workouts
            try cacheInteractor.save(data: [])
        }
        return try cacheInteractor.load()
    }
    
    func saveWorkouts(_ workouts: [CreatedWorkout]) throws {
        try cacheInteractor.save(data: workouts)
    }
}
