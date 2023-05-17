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
    func loadAvailableExercises() throws -> [String: AvailableExercise]
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
    
    func loadAvailableExercises() throws -> [String: AvailableExercise] {
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
            return mapExercises(exercises)
        }
        
        let exercises = try exerciseCacheInteractor.load()
        return mapExercises(exercises)
    }
    
    func saveAvailableExercises(_ exercises: [AvailableExercise]) throws {
        try exerciseCacheInteractor.save(data: exercises)
    }
    
    func saveWorkout(_ workout: Workout) throws {
        // First load the user's current workouts so we can prepend the new one
        if !(try workoutCacheInteractor.fileExists()) {
            // No workouts created yet, so just save the given one
            var workoutDict = [String: Workout]()
            workoutDict[workout.id] = workout
            try workoutCacheInteractor.save(data: workoutDict)
        } else {
            var workoutDict = try workoutCacheInteractor.load()
            workoutDict[workout.id] = workout // Add the new workout
            
            // Now save the new workout list
            try workoutCacheInteractor.save(data: workoutDict)
        }
    }
}

// MARK: - Private

private extension BuildWorkoutService {
    
    /// Converts an `AvailableExercise` list into a dictionary where the keys are the exercises IDs, and the values are the exercises.
    /// - Parameter exercises: The exercises
    /// - Returns: The ID -> exercise map
    func mapExercises(_ exercises: [AvailableExercise]) -> [String: AvailableExercise] {
        var map = [String: AvailableExercise]()
        
        exercises.forEach { exercise in
            map[exercise.id] = exercise
        }
        
        return map
    }
}
