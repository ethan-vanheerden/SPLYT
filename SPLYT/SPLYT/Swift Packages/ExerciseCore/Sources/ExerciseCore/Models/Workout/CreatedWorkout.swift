import Foundation

public struct CreatedWorkout: Codable, Equatable {
    public let workout: Workout
    // This is the filename to where the cached history for this workout is
    public let filename: String
    public let createdAt: Date
    
    public init(workout: Workout,
                filename: String,
                createdAt: Date) {
        self.workout = workout
        self.filename = filename
        self.createdAt = createdAt
    }
}
