import Foundation

/// Using a struct here since having these all be associated values in an enum hurts me
public struct RepsWeightInput: Codable, Equatable {
    // Weight first, then reps
    public let weight: Double?
    public let weightPlaceholder: Double?
    public let reps: Int?
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
}
