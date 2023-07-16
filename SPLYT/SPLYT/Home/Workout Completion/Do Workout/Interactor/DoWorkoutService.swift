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
    func loadWorkout(workoutId: String, historyFilename: String, planId: String?) throws -> Workout
    func saveWorkout(workout: Workout, historyFilename: String, planId: String?) throws
}

// MARK: - Errors

enum DoWorkoutError: Error {
    case workoutNoExist
}

// MARK: - Implementation

struct DoWorkoutService: DoWorkoutServiceType {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService()) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
    }
    
    func loadWorkout(workoutId: String, historyFilename: String, planId: String? = nil) throws -> Workout {
        let request = WorkoutHistoryCacheRequest(filename: historyFilename)
        
        if !(try cacheInteractor.fileExists(request: request)) {
            // If this is their first time doing this workout, we will load the workout for the first time
            let workout = try routineService.loadWorkout(workoutId: workoutId, planId: planId)
            return workout
        } else {
            // Load the most recent version they completed this specific workout (should be head of list)
            let workouts = try cacheInteractor.load(request: request)
            guard let workout = workouts.first else { throw DoWorkoutError.workoutNoExist }
            return workout
        }
    }
    
    func saveWorkout(workout: Workout, historyFilename: String, planId: String? = nil) throws {
        let historyRequest = WorkoutHistoryCacheRequest(filename: historyFilename)
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        var workout = workout
        workout.lastCompleted = Date.now
        
        // First save the workout-specific history
        if !(try cacheInteractor.fileExists(request: historyRequest)) {
            // If the file doesn't exist, save this workout as the only history
            try cacheInteractor.save(request: historyRequest, data: [workout])
        } else {
            // Load the existing history and place this workout at the head
            // Truncate the list to the last 10 workouts
            var workouts = try cacheInteractor.load(request: historyRequest)
            workouts.insert(workout, at: 0)
            let truncatedWorkouts = Array(workouts.prefix(10))
            try cacheInteractor.save(request: historyRequest, data: truncatedWorkouts)
        }
        
        // Then save this version of the workout to the created routines
        try routineService.saveWorkout(workout: workout,
                                       planId: planId,
                                       lastCompletedDate: Date.now)
    }
}
