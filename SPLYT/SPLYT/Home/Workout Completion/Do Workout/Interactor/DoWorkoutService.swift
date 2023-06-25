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
    func loadWorkout(filename: String, workoutId: String) throws -> Workout
    func saveWorkout(workout: Workout, filename: String) throws
}

// MARK: - Errors

enum DoWorkoutError: Error {
    case workoutNoExist
}

// MARK: - Implementation

struct DoWorkoutService: DoWorkoutServiceType {
    private let cacheInteractor: CacheInteractorType
    private let workoutService: CreatedWorkoutsServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         workoutService: CreatedWorkoutsServiceType = CreatedWorkoutsService()) {
        self.cacheInteractor = cacheInteractor
        self.workoutService = workoutService
    }
    
    func loadWorkout(filename: String, workoutId: String) throws -> Workout {
        let request = WorkoutHistoryCacheRequest(filename: filename)
        
        if !(try cacheInteractor.fileExists(request: request)) {
            // If this is their first time doing this workout, we will load the workout for the first time
            let createdWorkout = try workoutService.loadWorkout(id: workoutId)
            return createdWorkout.workout
        } else {
            // Load the most recent version they completed this specific workout (should be head of list)
            let workouts = try cacheInteractor.load(request: request)
            guard let workout = workouts.first else { throw DoWorkoutError.workoutNoExist }
            return workout
        }
    }
    
    func saveWorkout(workout: Workout, filename: String) throws {
        let request = WorkoutHistoryCacheRequest(filename: filename)
        // Update the workout's last completed date
        var workout = workout
        workout.lastCompleted = Date.now
        
        // First save the workout-specific history
        if !(try cacheInteractor.fileExists(request: request)) {
            // If the file doesn't exist, save this workout as the only history
            try cacheInteractor.save(request: request, data: [workout])
        } else {
            // Load the existing history and place this workout at the head
            // TODO: Do we want to limit how many we store here?
            var workouts = try cacheInteractor.load(request: request)
            workouts.insert(workout, at: 0)
            try cacheInteractor.save(request: request, data: workouts)
        }
        
        // Then save this version of the workout to the all workout list
        let createdWorkout = try workoutService.loadWorkout(id: workout.id)
        let newCreatedWorkout = CreatedWorkout(workout: workout,
                                               filename: createdWorkout.filename,
                                               createdAt: createdWorkout.createdAt)
        try workoutService.saveWorkout(newCreatedWorkout)
        
    }
}
