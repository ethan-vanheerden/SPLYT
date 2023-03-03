//
//  HomeServiceType.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 12/23/22.
//

import Foundation
import Caching

// MARK: - Protocol

protocol HomeServiceType {
    func loadWorkouts() throws -> [Workout]
}

// MARK: - Implementation

struct HomeService<T: CacheInteractorType>: HomeServiceType where T.Request == CreatedWorkoutsCacheRequest {
    private let cacheInteractor: T
    
    init(cacheInteractor: T = CacheInteractor(request: CreatedWorkoutsCacheRequest())) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadWorkouts() throws -> [Workout] {
        // First check if they have any saved workouts yet
        if !(try cacheInteractor.fileExists()) {
            // Create the file by saving an empty list of workouts
            try cacheInteractor.save(data: [])
        }
        return try cacheInteractor.load()
    }
}
