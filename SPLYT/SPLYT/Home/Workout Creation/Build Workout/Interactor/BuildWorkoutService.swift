//
//  BuildWorkoutService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import Caching
import ExerciseCore

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
        // The workout filename will be "workout_history_{workout_id}"
        let createdWorkout = CreatedWorkout(workout: workout,
                                            filename: "workout_history_\(workout.id)",
                                            createdAt: Date.now)
        // First load the user's current workouts so we can add the new one
        if !(try workoutCacheInteractor.fileExists()) {
            // No workouts created yet, so just save the new one
            try workoutCacheInteractor.save(data: [createdWorkout])
        } else {
            var createdWorkouts = try workoutCacheInteractor.load()
            createdWorkouts.insert(createdWorkout, at: 0)
            
            // Now save the new workout list
            try workoutCacheInteractor.save(data: createdWorkouts)
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
