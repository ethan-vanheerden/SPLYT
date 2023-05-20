import Foundation

public struct TimeInput: InputType, Hashable {
    public let seconds: Int?
    public let placeholder: Int?
    
    public init(seconds: Int? = nil,
                placeholder: Int? = nil) {
        self.seconds = seconds
        self.placeholder = placeholder
    }
    
    public var hasPlaceholder: Bool {
        return placeholder != nil
    }
}
