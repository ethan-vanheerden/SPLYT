import Foundation
import Caching

// MARK: - Protocol

/// Operations needed with a user's created routines.
public protocol CreatedRoutinesServiceType {
    /// Routine actions
    func loadRoutines() throws -> CreatedRoutines
    
    func saveRoutines(_: CreatedRoutines) throws
    
    /// Workout actions
    
    /// Loads the workout with the given id.
    /// - Parameters:
    ///   - workoutId: The id of the workout
    ///   - planId: The id of the plan which owns this workout if this workout is in a plan
    /// - Returns: The workout
    func loadWorkout(workoutId: String, planId: String?) throws -> Workout
    
    /// Saves the given workout.
    /// - Parameters:
    ///   - workout: The workout to save
    ///   - planId: The plan to save the workout to, if any
    ///   - lastCompletedDate: The date the workout was last completed, if any
    func saveWorkout(workout: Workout, planId: String?, lastCompletedDate: Date?) throws
    
    /// Plan actions
    
    func loadPlan(id: String) throws -> Plan
    
    func savePlan(_: Plan) throws
}

// MARK: - Implementation

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
    
    public func loadWorkout(workoutId: String, planId: String?) throws -> Workout {
        let routines = try loadRoutines()
        var workout: Workout?
        
        if let planId = planId {
            workout = routines.plans[planId]?.workouts.first { $0.id == workoutId }
        } else {
            workout = routines.workouts[workoutId]
        }
        
        guard let workout = workout else {
            throw Errors.notFound
        }
        
        return workout
    }
    
    public func saveWorkout(workout: Workout, planId: String?, lastCompletedDate: Date?) throws {
        var routines = try loadRoutines()
        var workout = workout
        workout.lastCompleted = lastCompletedDate ?? workout.lastCompleted
        
        if let planId = planId {
            // Replace the workout in the plan with the new one
            guard var plan = routines.plans[planId],
                  let workoutIndex = plan.workouts.firstIndex(where: { $0.id == workout.id }) else {
                throw Errors.notFound
            }
            plan.lastCompleted = lastCompletedDate ?? plan.lastCompleted
            plan.workouts[workoutIndex] = workout
            routines.plans[planId] = plan
        } else {
            routines.workouts[workout.id] = workout
        }
        
        try saveRoutines(routines)
    }
    
    public func loadPlan(id: String) throws -> Plan {
        let routines = try loadRoutines()
        
        guard let plan = routines.plans[id] else {
            throw Errors.notFound
        }
        
        return plan
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
