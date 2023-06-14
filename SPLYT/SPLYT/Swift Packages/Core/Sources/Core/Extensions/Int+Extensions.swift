import Foundation

public extension Int {
    
    /// Constructs a new optional integer from an optional double, creating nil if the double is nil.
    /// - Parameter double: The double to create the integer from
    init?(_ double: Double?) {
        guard let double = double else { return nil }
        self.init(double)
    }
}
