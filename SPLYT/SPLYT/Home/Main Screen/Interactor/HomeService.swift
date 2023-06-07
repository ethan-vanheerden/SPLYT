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
}

// MARK: - Implementation

struct HomeService: HomeServiceType {
    private let cacheInteractor: CacheInteractor.Type
    private let cacheRequest = CreatedWorkoutsCacheRequest()
    
    init(cacheInteractor: CacheInteractor.Type = CacheInteractor.self) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkouts() throws -> [String: CreatedWorkout] {
        // First check if they have any saved workouts yet
        if !(try cacheInteractor.fileExists(request: cacheRequest)) {
            // Create the file by saving an empty dictionary of workouts
            try cacheInteractor.save(request: cacheRequest, data: [:])
        }
        return try cacheInteractor.load(request: cacheRequest)
    }
    
    func saveWorkouts(_ workouts: [String: CreatedWorkout]) throws {
        try cacheInteractor.save(request: cacheRequest, data: workouts)
    }
}
