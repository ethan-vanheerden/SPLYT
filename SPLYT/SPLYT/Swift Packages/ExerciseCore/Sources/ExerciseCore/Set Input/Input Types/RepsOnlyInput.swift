import Foundation

public struct RepsOnlyInput: InputType {
    public let reps: Int?
    public let placeholder: Int?
    
    public init(reps: Int? = nil,
                placeholder: Int? = nil) {
        self.reps = reps
        self.placeholder = placeholder
    }
    
    public var hasPlaceholder: Bool {
        return placeholder != nil
    }
}
