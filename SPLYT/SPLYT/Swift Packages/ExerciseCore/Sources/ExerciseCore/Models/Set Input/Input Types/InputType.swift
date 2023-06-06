import Foundation

public protocol InputType: Codable, Equatable {
    /// Determines if this input type has an inputted value.
    var hasValue: Bool { get }
    
    /// Determines if this input type has a placeholder.
    var hasPlaceholder: Bool { get }
    
//    /// Gets the string value of this input type.
//    var stringValue: String { get }
//    
    /// Gets a new input where the values are this input'
//    var getPlaceholderInput: any InputType { get }
}
