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
    func loadAvailableExercises() async throws -> [String: AvailableExercise]
    func saveAvailableExercises(_: [AvailableExercise]) throws
    func saveWorkout(_: Workout) throws
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
    private let DAYS_FOR_RESYNC = 1
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService(),
         apiInteractor: APIInteractorType.Type = APIInteractor.self,
         userSettings: UserSettings = UserDefaults.standard,
         userAuth: UserAuthType = UserAuth(),
         currentDate: Date = Date.now) {
        self.cacheInteractor = cacheInteractor
        self.routineService = routineService
        self.apiInteractor = apiInteractor
        self.userSettings = userSettings
        self.userAuth = userAuth
        self.currentDate = currentDate
    }
    
    func loadAvailableExercises() async throws -> [String: AvailableExercise] {
        // Load from the API if it has been a while
        // If API fails or it has not been a while, load from cache
        // If API call succeeds, update cached copy
        
        let lastSynced = userSettings.object(forKey: .lastSyncedExercises)
        
        guard let lastSynced = lastSynced as? Date,
              Int(currentDate.timeIntervalSince(lastSynced) / 60 * 60 * 24) < DAYS_FOR_RESYNC else {
            
            do {
                let request = GetAvailableExercisesRequest(userAuth: userAuth)
                let exercises = (try await apiInteractor.performRequest(with: request)).responseObject
                
                
                // API call and update sync and cache here
                // TODO: favorite cascading
                
            } catch {
                // If API call failed, just try loading from cache
                return try loadFromCache()
            }
            // Sync now and update the last synced and the cache
            return try loadFromCache()
        }
        
        return try loadFromCache()
    }
    
    func saveAvailableExercises(_ exercises: [AvailableExercise]) throws {
        let request = AvailableExercisesCacheRequest()
        try cacheInteractor.save(request: request, data: exercises)
    }
    
    func saveWorkout(_ workout: Workout) throws {
        try routineService.saveWorkout(workout: workout,
                                       planId: nil,
                                       lastCompletedDate: nil)
    }
}

// MARK: - Private

private extension BuildWorkoutService {
    
    /// Loads the exercises from the cache.
    /// - Returns: A map of the exercise ID to the actual exercise
    func loadFromCache() throws -> [String: AvailableExercise] {
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
