import Foundation
import ExerciseCore
import Networking
import UserSettings
import UserAuth
import Caching

// MARK: - Protocol

protocol WorkoutServiceType {
    /// Handles loading the list of availabile exercises. This will make a network request if it has been a certain
    /// amount of time since the last fetch. This handles fetching the user's favorites and caching
    /// the response as well.
    /// - Returns: A map of exercise ID to the exercise
    func loadAvailableExercises() async throws -> [String: AvailableExercise]
    
    /// Loads the exercises directly from the cache without making a network request.
    /// - Returns: A map of the exercise ID to the actual exercise
    func loadFromCache() throws -> [String: AvailableExercise]
    
    /// Saves the available exercise map to cache with the specified favorites.
    /// - Parameter exercises: The exercises map
    /// - Parameter favorites: The user's favorite exercise IDs
    /// - Parameter unfavoritedExerciseID: The exercise ID which was unfavorited
    /// - Returns: The saved ID -> exercise map
    @discardableResult
    func updateExerciseCache(exerciseMap: inout [String: AvailableExercise],
                             favorites: [String],
                             unfavoritedExerciseID: String?) throws -> [String: AvailableExercise]
}

// MARK: - Implementation

struct WorkoutService: WorkoutServiceType {
    private let cacheInteractor: CacheInteractorType
    private let apiInteractor: APIInteractorType.Type
    private let userSettings: UserSettings
    private let userAuth: UserAuthType
    private let currentDate: Date
    
    /*
     To prevent fetching a very long list of exercises every time the user wants to build a
     workout (which can happen a lot when building a plan), we set a sync period so they only
     fetch once during a specified timeframe.
     */
    private let DAYS_FOR_RESYNC = 2
    
    init(cacheInteractor: CacheInteractorType = CacheInteractor(),
         routineService: CreatedRoutinesServiceType = CreatedRoutinesService(),
         apiInteractor: APIInteractorType.Type = APIInteractor.self,
         userSettings: UserSettings = UserDefaults.standard,
         userAuth: UserAuthType = UserAuth(),
         currentDate: Date = Date.now) {
        self.cacheInteractor = cacheInteractor
        self.apiInteractor = apiInteractor
        self.userSettings = userSettings
        self.userAuth = userAuth
        self.currentDate = currentDate
    }
    
    func loadAvailableExercises() async throws -> [String : AvailableExercise] {
        let lastSynced = userSettings.object(forKey: .lastSyncedExercises)
        
        let favoritesRequest = GetFavoriteExercisesRequest(userAuth: userAuth)
        let favoritesResponse = try await apiInteractor.performRequest(with: favoritesRequest).responseBody
        
        guard let lastSynced = lastSynced as? Date,
              Int(currentDate.timeIntervalSince(lastSynced) / (60 * 60 * 24)) < DAYS_FOR_RESYNC else {
            do {
                print("Fetching exercises...")
                let exercisesRequest = GetAvailableExercisesRequest(userAuth: userAuth)
                
                let exercisesResponse = try await apiInteractor.performRequest(with: exercisesRequest).responseBody
                
                var exerciseMap = mapExercises(exercisesResponse.exercises)
                let result = try updateExerciseCache(exerciseMap: &exerciseMap,
                                                     favorites: favoritesResponse.userFavorites,
                                                     unfavoritedExerciseID: nil)
                
                userSettings.set(currentDate, forKey: .lastSyncedExercises)
                return result
            } catch {
                // If API call failed, just try loading from cache
                return try loadFromCache()
            }
        }
        
        // If we fetched the exercises recently, just load from the cache
        var cachedExercises = try loadFromCache()
        return try updateExerciseCache(exerciseMap: &cachedExercises,
                                       favorites: favoritesResponse.userFavorites,
                                       unfavoritedExerciseID: nil)
    }
    
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
            
            // Now save the fallback data to the cache
            var exerciseMap = mapExercises(exercises)
            return try updateExerciseCache(exerciseMap: &exerciseMap,
                                           favorites: [],
                                           unfavoritedExerciseID: nil)
        }
        
        return try cacheInteractor.load(request: request)
    }
    
    @discardableResult
    func updateExerciseCache(exerciseMap: inout [String: AvailableExercise],
                             favorites: [String],
                             unfavoritedExerciseID: String?) throws -> [String: AvailableExercise] {
        for favoriteId in favorites {
            exerciseMap[favoriteId]?.isFavorite = true
        }
        
        if let unfavoritedExerciseID = unfavoritedExerciseID {
            exerciseMap[unfavoritedExerciseID]?.isFavorite = false
        }
        
        let request = AvailableExercisesCacheRequest()
        try cacheInteractor.save(request: request, data: exerciseMap)
        
        return exerciseMap
    }
}

// MARK: - Private

private extension WorkoutService {
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
