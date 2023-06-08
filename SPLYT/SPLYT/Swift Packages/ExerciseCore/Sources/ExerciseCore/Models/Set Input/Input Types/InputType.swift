import Foundation

public protocol InputType: Codable, Equatable {
    /// Determines if this input type has an inputted value.
    var hasValue: Bool { get }
    
    /// Determines if this input type has a placeholder.
    var hasPlaceholder: Bool { get }
}
