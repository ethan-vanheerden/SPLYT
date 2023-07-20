import Foundation

/// A saved workout and its history. This is mainly used so we can get a unique id across multiple
/// completed versions of the same workout.
public struct WorkoutHistory: Codable, Equatable {
    public let id: String
    public let workout: Workout
    
    public init(id: String,
                workout: Workout) {
        self.id = id
        self.workout = workout
    }
}
