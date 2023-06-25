import Foundation

/// Represents a series of workouts executed together
public struct Plan: Codable, Equatable {
    public let id: String
    public let name: String
    public var workouts: [Workout]
    public var createdAt: Date
    public var lastCompleted: Date?
    
    public init(id: String,
                name: String,
                workouts: [Workout],
                createdAt: Date,
                lastCompleted: Date? = nil) {
        self.id = id
        self.name = name
        self.workouts = workouts
        self.createdAt = createdAt
        self.lastCompleted = lastCompleted
    }
}
