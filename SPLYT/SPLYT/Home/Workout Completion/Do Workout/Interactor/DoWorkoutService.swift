//
//  DoWorkoutService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 5/17/23.
//

import Foundation
import Caching
import ExerciseCore
import UserSettings
import Core

// MARK: - Protocol

protocol DoWorkoutServiceType {
    func loadWorkout(workoutId: String, planId: String?) throws -> Workout
    // Returns the saved workout history ID
    func saveWorkout(workout: Workout, planId: String?, completionDate: Date) throws -> String
    func loadRestPresets() -> [Int]
}

// MARK: - Errors

enum DoWorkoutError: Error {
    case workoutNoExist
}

// MARK: - Implementation

struct DoWorkoutService: DoWorkoutServiceType {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    private let userSettings: UserSettings
    private let screenLocker: ScreenLockerType
    private let fallbackRestPresets: [Int] = [60, 90, 120]
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService(),
         userSettings: UserSettings = UserDefaults.standard,
         screenLocker: ScreenLockerType = ScreenLocker()) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
        self.userSettings = userSettings
        self.screenLocker = screenLocker
    }
    
    func loadWorkout(workoutId: String, planId: String? = nil) throws -> Workout {
        let workout = try routineService.loadWorkout(workoutId: workoutId, planId: planId)
        screenLocker.disableAutoLock()
        return workout
    }
    
    func saveWorkout(workout: Workout, planId: String? = nil, completionDate: Date) throws -> String {
        let completedWorkoutsRequest = CompletedWorkoutsCacheRequest()
        var workout = workout
        workout.lastCompleted = completionDate
        
        // Re-enable auto lock even if we get some sort of error
        screenLocker.enableAutoLock()
        
        // Save this version of the workout to the created routines
        try routineService.saveWorkout(workout: workout,
                                       planId: planId,
                                       lastCompletedDate: completionDate)
        
        // Then load the existing history and place this workout at the head
        var completedWorkouts = try cacheInteractor.load(request: completedWorkoutsRequest)
        
        // Construct the new history id using the current date and the workout's id
        let historyId = WorkoutInteractor.getId(name: workout.id, creationDate: completionDate)
        let workoutHistory = WorkoutHistory(id: historyId,
                                            workout: workout)
        
        completedWorkouts.insert(workoutHistory, at: 0)
        try cacheInteractor.save(request: completedWorkoutsRequest, data: completedWorkouts)
        
        return historyId
    }
    
    func loadRestPresets() -> [Int] {
        let presets = userSettings.object(forKey: .restPresets)
        
        guard let presets = presets as? [Int] else {
            return fallbackRestPresets
        }
        
        return presets
    }
}
