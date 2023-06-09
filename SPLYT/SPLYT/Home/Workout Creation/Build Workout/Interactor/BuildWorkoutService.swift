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

struct BuildWorkoutService: BuildWorkoutServiceType  {
    private let cacheInteractor: CacheInteractorType.Type
    private let workoutService: CreatedWorkoutsServiceType
    
    init(cacheInteractor: CacheInteractorType.Type = CacheInteractor.self,
         workoutService: CreatedWorkoutsServiceType = CreatedWorkoutsService()) {
        self.cacheInteractor = cacheInteractor
        self.workoutService = workoutService
    }
    
    func loadAvailableExercises() throws -> [String: AvailableExercise] {
        let request = AvailableExercisesCacheRequest()
        // First check if the user has the cached AvailableExercise file yet
        if !(try cacheInteractor.fileExists(request: request)) {
            
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
        
        let exercises = try cacheInteractor.load(request: request)
        return mapExercises(exercises)
    }
    
    func saveAvailableExercises(_ exercises: [AvailableExercise]) throws {
        let request = AvailableExercisesCacheRequest()
        try cacheInteractor.save(request: request, data: exercises)
    }
    
    func saveWorkout(_ workout: Workout) throws {
        // The workout filename will be "workout_history_{workout_id}"
        let createdWorkout = CreatedWorkout(workout: workout,
                                            filename: "workout_history_\(workout.id)",
                                            createdAt: Date.now)
        try workoutService.saveWorkout(createdWorkout)
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
