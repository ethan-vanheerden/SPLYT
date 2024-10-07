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
import Notifications

// MARK: - Protocol

protocol DoWorkoutServiceType {
    func loadWorkout(workoutId: String, planId: String?) throws -> Workout
    // Returns the saved workout history ID
    func saveWorkout(workout: Workout, planId: String?, completionDate: Date) throws -> String
    func loadRestPresets() -> [Int]
    func loadInProgressWorkout() throws -> InProgressWorkout
    func saveInProgressWorkout(_: InProgressWorkout)
    func deleteInProgressWorkoutCache() throws
    func scheduleRestNotifcation(workoutId: String, after: Int) async throws
    func deleteRestNotification(workoutId: String)
    func playRestTimerSound() throws
    func loadExercise(exerciseId: String) async throws -> AvailableExercise
}

// MARK: - Errors

enum DoWorkoutError: Error {
    case workoutNoExist
    case exerciseNotFound
}

// MARK: - Implementation

struct DoWorkoutService: DoWorkoutServiceType {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    private let userSettings: UserSettings
    private let screenLocker: ScreenLockerType
    private let notificationInteractor: NotificationInteractorType
    private let audioPlayer: AudioPlayerType
    private let workoutService: WorkoutServiceType
    private let fallbackRestPresets: [Int] = [60, 90, 120]
    private let inProgressCacheRequest = InProgressWorkoutCacheRequest()
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService(),
         userSettings: UserSettings = UserDefaults.standard,
         screenLocker: ScreenLockerType = ScreenLocker(),
         notificationInteractor: NotificationInteractorType = NotificationInteractor(),
         audioPlayer: AudioPlayerType = AudioPlayer(),
         workoutService: WorkoutServiceType? = nil) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
        self.userSettings = userSettings
        self.screenLocker = screenLocker
        self.notificationInteractor = notificationInteractor
        self.audioPlayer = audioPlayer
        self.workoutService = workoutService ?? WorkoutService(cacheInteractor: cacheInteractor,
                                                               userSettings: userSettings)
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
    
    func loadInProgressWorkout() throws -> InProgressWorkout {
        screenLocker.disableAutoLock() // Re-enable if coming back from a crash
        
        return try cacheInteractor.load(request: inProgressCacheRequest)
    }
    
    func saveInProgressWorkout(_ inProgressWorkout: InProgressWorkout) {
        // Fail gracefully so the user can still complete their workout
        do {
            try cacheInteractor.save(request: inProgressCacheRequest,
                                     data: inProgressWorkout)
        } catch { }
    }
    
    func deleteInProgressWorkoutCache() throws {
        try cacheInteractor.deleteFile(request: inProgressCacheRequest)
    }
    
    func scheduleRestNotifcation(workoutId: String, after seconds: Int) async throws {
        let notification = Notification(id: workoutId,
                                        type: .restTimer,
                                        title: Strings.restPeriodComplete,
                                        description: Strings.continueWorkout,
                                        isTimeSensitive: true)
        
        try await notificationInteractor.scheduleNotification(notification: notification,
                                                              after: seconds)
    }
    
    func deleteRestNotification(workoutId: String) {
        notificationInteractor.deleteNotification(id: workoutId)
    }
    
    func playRestTimerSound() throws {
        try audioPlayer.playSound(.restTimer)
    }
    
    func loadExercise(exerciseId: String) async throws -> AvailableExercise {
        let availableExercises = try await workoutService.loadAvailableExercises()
        
        guard let availableExercise = availableExercises[exerciseId] else {
            throw DoWorkoutError.exerciseNotFound
        }
        
        return availableExercise
    }
}

// MARK: - Strings

fileprivate struct Strings {
    static let restPeriodComplete = "Rest Period Complete!"
    static let continueWorkout = "Continue your workout now 💪"
}
