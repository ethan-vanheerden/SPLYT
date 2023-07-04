import Foundation
import Caching

// MARK: - Protocol

/// Operations needed with the user's created routines.
public protocol CreatedRoutinesServiceType {
    /// Routine actions
    func loadRoutines() throws -> CreatedRoutines
    
    func saveRoutines(_: CreatedRoutines) throws
    
    /// Workout actions
    func loadWorkout(id: String) throws -> Workout
    
    func saveWorkouts(_: [String: Workout]) throws
    
    func saveWorkout(_: Workout) throws
    
    /// Plan actions
    func loadPlan(id: String) throws -> Plan
    
    func savePlans(_: [String: Plan]) throws
    
    func savePlan(_: Plan) throws
}

// MARK: - Implementation

///  Service for getting a user's created workouts
public struct CreatedRoutinesService: CreatedRoutinesServiceType {
    typealias Errors = CreatedRoutinesServiceError
    private let cacheInteractor: CacheInteractorType
    private let cacheRequest = CreatedRoutinesCacheRequest()
    
    public init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    public func loadRoutines() throws -> CreatedRoutines {
        try saveEmptyRoutinesIfNeeded()
        return try cacheInteractor.load(request: cacheRequest)
    }
    
    public func saveRoutines(_ routines: CreatedRoutines) throws {
        try cacheInteractor.save(request: cacheRequest, data: routines)
    }
    
    public func loadWorkout(id: String) throws -> Workout {
        let routines = try loadRoutines()
        
        guard let workout = routines.workouts[id] else {
            throw Errors.notFound
        }
        
        return workout
    }
    
    public func saveWorkouts(_ workouts: [String: Workout]) throws {
        var routines = try loadRoutines()
        routines.workouts = workouts
        try saveRoutines(routines)
    }
    
    public func saveWorkout(_ workout: Workout) throws {
        var routines = try loadRoutines()
        routines.workouts[workout.id] = workout
        try saveRoutines(routines)
    }
    
    public func loadPlan(id: String) throws -> Plan {
        let routines = try loadRoutines()
        
        guard let plan = routines.plans[id] else {
            throw Errors.notFound
        }
        
        return plan
    }
    
    public func savePlans(_ plans: [String : Plan]) throws {
        var routines = try loadRoutines()
        routines.plans = plans
        try saveRoutines(routines)
    }
    
    public func savePlan(_ plan: Plan) throws {
        var routines = try loadRoutines()
        routines.plans[plan.id] = plan
        try saveRoutines(routines)
    }
}

// MARK: - Private

private extension CreatedRoutinesService {
    /// Creates the cached file with empty routines if one doesn't exist yet.
    func saveEmptyRoutinesIfNeeded() throws {
        // First check if they have any saved routines yet
        if !(try cacheInteractor.fileExists(request: cacheRequest)) {
            let emptyRoutines = CreatedRoutines(workouts: [:], plans: [:])
            try saveRoutines(emptyRoutines)
        }
    }
}

// MARK: - Errors

enum CreatedRoutinesServiceError: Error {
    case notFound
}
