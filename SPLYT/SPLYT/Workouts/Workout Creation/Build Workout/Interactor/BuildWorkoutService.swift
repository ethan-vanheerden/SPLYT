//
//  BuildWorkoutService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import Caching

// MARK: - Protocol

protocol BuildWorkoutServiceType {
    func loadAvailableExercises() throws -> [AvailableExercise]
    func saveAvailableExercises(_: [AvailableExercise]) throws
}

// MARK: - Errors

enum BuildWorkoutError: Error {
    case fallbackFileNotFound
}

// MARK: - Implementation

struct BuildWorkoutService<T: CacheInteractorType>: BuildWorkoutServiceType where T.Request == AvailableExercisesCacheRequest  {
    private let cacheInteractor: T
    
    init(cacheInteractor: T = CacheInteractor(request: AvailableExercisesCacheRequest())) {
        self.cacheInteractor = cacheInteractor
    }
    
    func loadAvailableExercises() throws -> [AvailableExercise] {
        // First check if the user has the cached AvailableExercise file yet
        if !(try cacheInteractor.fileExists()) {
            
            // Save the fallback file
            guard let url = Bundle.main.url(forResource: "fallback_exercises", withExtension: "json") else {
                throw BuildWorkoutError.fallbackFileNotFound
            }
            
            let data = try Data(contentsOf: url)
            let exercises = try JSONDecoder().decode([AvailableExercise].self, from: data)
            
            // Now save the data
            try saveAvailableExercises(exercises)
            return exercises
        }
        
        let exercises = try cacheInteractor.load()
        return exercises
    }
    
    func saveAvailableExercises(_ exercises: [AvailableExercise]) throws {
        try cacheInteractor.save(data: exercises)
    }
}
