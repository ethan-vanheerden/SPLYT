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
