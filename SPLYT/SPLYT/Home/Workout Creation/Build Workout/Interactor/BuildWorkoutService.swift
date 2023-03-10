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
    func saveWorkout(_: Workout) throws
}

// MARK: - Errors

enum BuildWorkoutError: Error {
    case fallbackFileNotFound
}

// MARK: - Implementation

struct BuildWorkoutService<T: CacheInteractorType, U: CacheInteractorType>: BuildWorkoutServiceType where T.Request == AvailableExercisesCacheRequest, U.Request == CreatedWorkoutsCacheRequest  {
    private let exerciseCacheInteractor: T
    private let workoutCacheInteractor: U
    
    init(exerciseCacheInteractor: T = CacheInteractor(request: AvailableExercisesCacheRequest()),
         workoutCacheInteractor: U = CacheInteractor(request: CreatedWorkoutsCacheRequest())) {
        self.exerciseCacheInteractor = exerciseCacheInteractor
        self.workoutCacheInteractor = workoutCacheInteractor
    }
    
    func loadAvailableExercises() throws -> [AvailableExercise] {
        // First check if the user has the cached AvailableExercise file yet
        if !(try exerciseCacheInteractor.fileExists()) {
            
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
        
        let exercises = try exerciseCacheInteractor.load()
        return exercises
    }
    
    func saveAvailableExercises(_ exercises: [AvailableExercise]) throws {
        try exerciseCacheInteractor.save(data: exercises)
    }
    
    func saveWorkout(_ workout: Workout) throws {
        // First load the user's current workouts so we can prepend the new one
        if !(try workoutCacheInteractor.fileExists()) {
            // No workouts created yet, so just ssave the given one
            try workoutCacheInteractor.save(data: [workout])
        } else {
            var workouts = try workoutCacheInteractor.load()
            workouts.insert(workout, at: 0)
            
            // Now save the new workout list
            try workoutCacheInteractor.save(data: workouts)
        }
    }
}
