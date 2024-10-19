//
//  BuildWorkoutService.swift
//  SPLYT
//
//  Created by Ethan Van Heerden on 1/11/23.
//

import Foundation
import Caching
import ExerciseCore
import UserSettings
import Networking
import UserAuth

// MARK: - Protocol

protocol BuildWorkoutServiceType {
    /// Loads the available exercises.
    /// - Returns: A map of the exercise ID to the `AvailableExercise`
    func loadAvailableExercises() async throws -> [String: AvailableExercise]
    
    /// Toggles the favorite of an exercise.
    /// - Parameters:
    ///   - exerciseId: The exercise ID to toggle
    ///   - isFavorite: Whether or not the exericse is favorited or not
    func toggleFavorite(exerciseId: String, isFavorite: Bool) async throws
    
    /// Saves the given workout.
    /// - Parameter workout: The workout to save
    func saveWorkout(_ workout: Workout) throws
    
    /// Reloads the available exercises directly from the cache.
    /// - Returns: A map of the exercise ID to each `AvailableExercise`
    func reloadCache() throws -> [String: AvailableExercise]
}

// MARK: - Errors

enum BuildWorkoutError: Error {
    case fallbackFileNotFound
}

// MARK: - Implementation

struct BuildWorkoutService: BuildWorkoutServiceType  {
    private let cacheInteractor: CacheInteractorType
    private let routineService: CreatedRoutinesServiceType
    private let apiInteractor: APIInteractorType.Type
    private let userSettings: UserSettings
    private let userAuth: UserAuthType
    private let currentDate: Date
    private let workoutService: WorkoutServiceType
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService(),
         apiInteractor: APIInteractorType.Type = APIInteractor.self,
         userSettings: UserSettings = UserDefaults.standard,
         userAuth: UserAuthType = UserAuth(),
         currentDate: Date = Date.now,
         workoutService: WorkoutServiceType? = nil) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
        self.apiInteractor = apiInteractor
        self.userSettings = userSettings
        self.userAuth = userAuth
        self.currentDate = currentDate
        self.workoutService = workoutService ?? WorkoutService(cacheInteractor: cacheInteractor,
                                                               routineService: routineService,
                                                               userSettings: userSettings,
                                                               userAuth: userAuth,
                                                               currentDate: currentDate)
    }
    
    func loadAvailableExercises() async throws -> [String: AvailableExercise] {
        return try await workoutService.loadAvailableExercises()
    }
    
    func toggleFavorite(exerciseId: String, isFavorite: Bool) async throws {
        let requestBody = UpdateFavoriteExerciseRequestBody(exerciseId: exerciseId,
                                                            isFavorite: isFavorite)
        let request = UpdateFavoriteExerciseRequest(requestBody: requestBody,
                                                    userAuth: userAuth)
        
        let favoritesResponse = try await apiInteractor.performRequest(with: request).responseBody
        
        // Update the favorites in the cache
        var cachedExercises = try workoutService.loadFromCache()
        try workoutService.updateExerciseCache(exerciseMap: &cachedExercises,
                                               favorites: favoritesResponse.userFavorites,
                                               unfavoritedExerciseID: isFavorite ? nil : exerciseId)
    }
    
    func saveWorkout(_ workout: Workout) throws {
        try routineService.saveWorkout(workout: workout,
                                       planId: nil,
                                       lastCompletedDate: nil)
    }
    
    func reloadCache() throws -> [String : AvailableExercise] {
        return try workoutService.loadFromCache()
    }
}
