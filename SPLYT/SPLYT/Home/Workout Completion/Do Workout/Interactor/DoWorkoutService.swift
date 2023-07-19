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
    func loadWorkout(workoutId: String, planId: String?) throws -> Workout
    func saveWorkout(workout: Workout, planId: String?, completionDate: Date) throws
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
    
    func loadWorkout(workoutId: String, planId: String? = nil) throws -> Workout {
        return try routineService.loadWorkout(workoutId: workoutId, planId: planId)
    }
    
    func saveWorkout(workout: Workout, planId: String? = nil, completionDate: Date) throws {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        var workout = workout
        workout.lastCompleted = completionDate
        
        // Save this version of the workout to the created routines
        try routineService.saveWorkout(workout: workout,
                                       planId: planId,
                                       lastCompletedDate: completionDate)
        
        // Then load the existing history and place this workout at the head
        var completedWorkouts = try cacheInteractor.load(request: completedWorkoutsRequest)
        completedWorkouts.insert(workout, at: 0)
        try cacheInteractor.save(request: completedWorkoutsRequest, data: completedWorkouts)
    }
}
