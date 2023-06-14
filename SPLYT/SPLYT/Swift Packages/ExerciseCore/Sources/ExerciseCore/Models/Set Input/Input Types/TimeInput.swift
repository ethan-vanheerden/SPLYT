import Foundation

public struct TimeInput: InputType, Hashable {
    public var seconds: Int?
    public let placeholder: Int?
    
    public init(seconds: Int? = nil,
                placeholder: Int? = nil) {
        self.seconds = seconds
        self.placeholder = placeholder
    }
    
    public var hasValue: Bool {
        return seconds != nil
    }
    
    public var hasPlaceholder: Bool {
        return placeholder != nil
    }
}
