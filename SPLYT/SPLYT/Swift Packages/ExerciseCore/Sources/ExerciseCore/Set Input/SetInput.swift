import Foundation

/// The data that is used to record a weightlifting set. All of the associated values are optional in case something is skipped.
public enum SetInput: Codable, Equatable {
    case repsWeight(input: RepsWeightInput)
    case repsOnly(input: RepsOnlyInput)
    case time(input: TimeInput)
    
    private enum CodingKeys: String, CodingKey {
        case repsWeight = "REPS_WEIGHT"
        case repsOnly = "REPS_ONLY"
        case time = "TIME"
    }
    
    /// Updates this set input given a new input. Note: we only want to update if the new input is the same type as this one,
    /// and we only update the associated values if the new values are not nil.
    /// - Parameter newInput: The new input to update this set with
    /// - Returns: The updated set input
    public func updateSetInput(with newInput: SetInput?) -> SetInput {
        guard let newInput = newInput else { return self }
        
        switch (self, newInput) {
        case let (.repsWeight(input: input), .repsWeight(input: newInput)):
            let updatedInput = RepsWeightInput(weight: newInput.weight ?? input.weight,
                                               weightPlaceholder: newInput.weightPlaceholder ?? input.weightPlaceholder,
                                               reps: newInput.reps ?? input.reps,
                                               repsPlaceholder: newInput.repsPlaceholder ?? input.repsPlaceholder)
            return .repsWeight(input: updatedInput)
        case let (.repsOnly(input: input), .repsOnly(input: newInput)):
            let updatedInput = RepsOnlyInput(reps: newInput.reps ?? input.reps,
                                             placeholder: newInput.placeholder ?? input.placeholder)
            return .repsOnly(input: updatedInput)
        case let (.time(input: input), .time(input: newInput)):
            let updatedInput = TimeInput(seconds: newInput.seconds ?? input.seconds,
                                         placeholder: newInput.placeholder ?? input.placeholder)
            return .time(input: updatedInput)
        default:
            return self // Don't do any updates
        }
    }
}
