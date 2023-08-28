import Foundation

public extension String {
    
    /// Constructs a string using the optional integer, creating "" or "--" if it is nil
    /// - Parameter int: The integer is create the string from
    /// - Parameter defaultDash: Whether or not to return "--" if the given Int is nil
    init(_ int: Int?, defaultDash: Bool = false) {
        var double: Double?
        if let int = int {
            double = Double(int)
        }
        self.init(double, defaultDash: defaultDash)
    }
    
    /// Constructs a string using the optional double, creating "" or "--" if it is nil. This gets rid of any decimals if the double is like "x.0"
    /// - Parameter double: The double to create the string from
    /// - Parameter defaultDash: Whether or not to return "--" if the given double is nil
    init(_ double: Double?, defaultDash: Bool = false) {
        guard let double = double else {
            self.init(defaultDash ? "--" : "")
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
    
    /// Determines if this string matches the given regex.
    /// https://stackoverflow.com/questions/29784447/swift-regex-does-a-string-match-a-pattern
    /// - Parameter regex: The regular expression to check the match of
    /// - Returns: Whether or not this string contains the regex
    func matches(_ regex: String) -> Bool {
            return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
        }
}
