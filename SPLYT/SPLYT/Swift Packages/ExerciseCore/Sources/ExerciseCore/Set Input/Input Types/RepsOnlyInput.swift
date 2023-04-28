import Foundation

public struct RepsOnlyInput: Codable, Equatable {
    public let reps: Int?
    public let placeholder: Int?
    
    public init(reps: Int? = nil,
                placeholder: Int? = nil) {
        self.reps = reps
        self.placeholder = placeholder
    }
}
