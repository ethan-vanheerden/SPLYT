import Foundation
import Caching

// MARK: - Protocol

/// Operations needed with the user's created workouts.
public protocol CreatedWorkoutsServiceType {
    func loadWorkouts() throws -> [String: CreatedWorkout]
    
    func loadWorkout(id: String) throws -> CreatedWorkout
    
    func saveWorkouts(_ workouts: [String: CreatedWorkout]) throws
    
    func saveWorkout(_ workout: CreatedWorkout) throws
}

// MARK: - Implementation

///  Service for getting a user's created workouts
public struct CreatedWorkoutsService: CreatedWorkoutsServiceType {
    private let cacheInteractor: CacheInteractorType
    private let cacheRequest = CreatedWorkoutsCacheRequest()
    
    public init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    public func loadWorkouts() throws -> [String: CreatedWorkout] {
        // First check if they have any saved workouts yet
        if !(try cacheInteractor.fileExists(request: cacheRequest)) {
            // Create the file by saving an empty dictionary of workouts
            try cacheInteractor.save(request: cacheRequest, data: [:])
        }
        return try cacheInteractor.load(request: cacheRequest)
    }
    
    public func loadWorkout(id: String) throws -> CreatedWorkout {
        let allWorkouts = try loadWorkouts()
        
        guard let workout = allWorkouts[id] else {
            throw CreatedWorkoutServiceError.workoutNotFound
        }
        
        return workout
    }
    
    public func saveWorkouts(_ workouts: [String: CreatedWorkout]) throws {
        try cacheInteractor.save(request: cacheRequest, data: workouts)
    }
    
    public func saveWorkout(_ workout: CreatedWorkout) throws {
        var allWorkouts = try loadWorkouts()
        allWorkouts[workout.workout.id] = workout
        try saveWorkouts(allWorkouts)
    }
}

// MARK: - Errors

enum CreatedWorkoutServiceError: Error {
    case workoutNotFound
}
