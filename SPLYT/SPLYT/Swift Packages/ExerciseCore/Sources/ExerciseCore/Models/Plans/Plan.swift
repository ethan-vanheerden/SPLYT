import Foundation

/// Represents a series of workouts executed together
public struct Plan: Codable, Equatable {
    public let id: String
    public let name: String
    public var workouts: [Workout]
    public var createdAt: Date?
}
