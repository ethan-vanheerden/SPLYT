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
    
//    /// Updates this set input given a new input. Note: we only want to update if the new input is the same type as this one,
//    /// and we only update the associated values if the new values are not nil.
//    /// - Parameter updatedInput: The new input to update this set with
//    /// - Parameter allowNilInput: If true, we don't do any of the nil collascing behavior, we just return
//    ///                            the new input if it is the same type as this one. This is so that we can set a field to nil if we want.
//    /// - Returns: The updated set input
//    public func updateSetInput(with updatedInput: SetInput?,
//                               allowNilInput: Bool) -> SetInput {
//        guard let updatedInput = updatedInput else { return self }
//
//        switch (self, updatedInput) {
//        case let (.repsWeight(input: input), .repsWeight(input: newInput)):
//            guard !allowNilInput else { return updatedInput }
//            let updatedInput = RepsWeightInput(weight: newInput.weight ?? input.weight,
//                                               weightPlaceholder: newInput.weightPlaceholder ?? input.weightPlaceholder,
//                                               reps: newInput.reps ?? input.reps,
//                                               repsPlaceholder: newInput.repsPlaceholder ?? input.repsPlaceholder)
//            return .repsWeight(input: updatedInput)
//        case let (.repsOnly(input: input), .repsOnly(input: newInput)):
//            guard !allowNilInput else { return updatedInput }
//            let updatedInput = RepsOnlyInput(reps: newInput.reps ?? input.reps,
//                                             placeholder: newInput.placeholder ?? input.placeholder)
//            return .repsOnly(input: updatedInput)
//        case let (.time(input: input), .time(input: newInput)):
//            guard !allowNilInput else { return updatedInput }
//            let updatedInput = TimeInput(seconds: newInput.seconds ?? input.seconds,
//                                         placeholder: newInput.placeholder ?? input.placeholder)
//            return .time(input: updatedInput)
//        default:
//            return self // Don't do any updates
//        }
//    }
    
    /// Creates a new set input where the actual values are the input's placeholders.
    /// If the input does not have a placeholder, the new input will not have inputs. The old placeholders are also kept.
    public var placeholderInput: SetInput {
        switch self {
        case .repsWeight(var input):
            input.weight = input.weightPlaceholder
            input.reps = input.repsPlaceholder
            return .repsWeight(input: input)
        case .repsOnly(var input):
            input.reps = input.placeholder
            return .repsOnly(input: input)
        case .time(var input):
            input.seconds = input.placeholder
            return .time(input: input)
        }
    }
}
