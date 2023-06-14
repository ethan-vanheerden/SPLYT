import Foundation

/// Using a struct here since having these all be associated values in an enum hurts me
public struct RepsWeightInput: InputType, Hashable {
    // Weight first, then reps
    public var weight: Double?
    public let weightPlaceholder: Double?
    public var reps: Int?
    public let repsPlaceholder: Int?
    
    public init(weight: Double? = nil,
                weightPlaceholder: Double? = nil,
                reps: Int? = nil,
                repsPlaceholder: Int? = nil) {
        self.weight = weight
        self.weightPlaceholder = weightPlaceholder
        self.reps = reps
        self.repsPlaceholder = repsPlaceholder
    }
    
    private enum CodingKeys: String, CodingKey {
        case weight
        case weightPlaceholder = "weight_placeholder"
        case reps
        case repsPlaceholder = "reps_placeholder"
    }
    
    public var hasValue: Bool {
        return weight != nil || reps != nil
    }
    
    public var hasPlaceholder: Bool {
        return weightPlaceholder != nil || repsPlaceholder != nil
    }
}
