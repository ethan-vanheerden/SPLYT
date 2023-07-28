import Foundation
import Caching

// MARK: - Protocol

/// Operations regarding a user's completed workouts.
public protocol CompletedWorkoutsServiceType {
    @discardableResult
    func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory]
}

// MARK: - Implementation

public struct CompletedWorkoutsService: CompletedWorkoutsServiceType {
    private let cacheInteractor: CacheInteractorType
    private let completedWorkoutsCacheRequest = CompletedWorkoutsCacheRequest()
    
    public init(cacheInteractor: CacheInteractorType = CacheInteractor()) {
        self.cacheInteractor = cacheInteractor
    }
    
    @discardableResult
    public func deleteWorkoutHistory(historyId: String) throws -> [WorkoutHistory] {
        var histories = try cacheInteractor.load(request: completedWorkoutsCacheRequest)
        histories.removeAll { $0.id == historyId }
        
        try cacheInteractor.save(request: completedWorkoutsCacheRequest, data: histories)
        
        return histories
    }
}

