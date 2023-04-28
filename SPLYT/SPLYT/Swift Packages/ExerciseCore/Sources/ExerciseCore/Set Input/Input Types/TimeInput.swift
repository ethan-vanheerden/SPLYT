import Foundation

public struct TimeInput: Codable, Equatable {
    public let seconds: Int?
    public let placeholder: Int?
    
    public init(seconds: Int? = nil,
                placeholder: Int? = nil) {
        self.seconds = seconds
        self.placeholder = placeholder
    }
}
