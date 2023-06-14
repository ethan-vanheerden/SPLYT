import Foundation

public extension String {
    
    /// Constructs a string using the optional integer, creating "" if it is nil
    /// - Parameter int: The integer is create the string from
    init(_ int: Int?) {
        guard let int = int else {
            self.init("")
            return
        }
        self.init("\(int)")
    }
    
    /// Constructs a string using the optional double, creating "" if it is nil. This gets rid of any decimals if the double is like "x.0"
    /// - Parameter double: The double to create the string from
    init(_ double: Double?) {
        guard let double = double else {
            self.init("")
            return
        }
        
        if double.remainder(dividingBy: 1) == 0 {
            // If there is nothing after the decimal, get rid of it
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            let value = formatter.string(from: NSNumber(value: double))
            self.init(value ?? "\(double)")
        } else {
            self.init("\(double)")
        }
    }
}
