
import Foundation

/// The data that is used to record a weightlifting set. All of the associated values are optional in case the set is skipped.
public enum SetInput: Codable, Equatable {
    case repsWeight(reps: Int?, weight: Double?)
    case repsOnly(reps: Int?)
    case time(seconds: Int?)
    
    private enum CodingKeys: String, CodingKey {
        case repsWeight = "REPS_WEIGHT"
        case repsOnly = "REPS_ONLY"
        case time = "TIME"
    }
    
    
    /// Updates this set input given a new input. Note: we only want to update if the new input is the same type as this one,
    /// and we only update the associated values if the new values are not nil.
    /// - Parameter newInput: The new input to update this set with
    /// - Returns: The updated set input
    public func updateSetInput(with newInput: SetInput) -> SetInput {
        switch (self, newInput) {
        case let (.repsWeight(reps, weight), .repsWeight(newReps, newWeight)):
            return .repsWeight(reps: newReps ?? reps,
                               weight: newWeight ?? weight)
        case let (.repsOnly(reps), .repsOnly(newReps)):
            return .repsOnly(reps: newReps ?? reps)
        case let (.time(seconds), .time(newSeconds)):
            return .time(seconds: newSeconds ?? seconds)
        default:
            return self // Don't do any updates
        }
    }
}


/// Determines the type of view shown for a particular set's input behavior.
public enum SetViewType: Equatable {
    case repsWeight(weightTitle: String, weightPlaceholder: Double? = nil, repsTitle: String, repsPlaceholder: Int? = nil)
    case repsOnly(title: String, placeholder: Int? = nil)
    case time(title: String, placeholder: Int? = nil)
}
