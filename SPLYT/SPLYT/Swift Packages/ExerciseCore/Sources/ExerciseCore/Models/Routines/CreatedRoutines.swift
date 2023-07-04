import Foundation

/// All the workouts and plans that a user has created
public struct CreatedRoutines: Codable, Equatable {
    public var workouts: [String: Workout]
    public var plans: [String: Plan]
}
