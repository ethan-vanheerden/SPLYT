import Foundation

public protocol InputType: Codable, Equatable {
    /// Determines if this input type has a placeholder
    var hasPlaceholder: Bool { get }
    
    /// Gets a new input where the values are this input'
//    var getPlaceholderInput: any InputType { get }
}
