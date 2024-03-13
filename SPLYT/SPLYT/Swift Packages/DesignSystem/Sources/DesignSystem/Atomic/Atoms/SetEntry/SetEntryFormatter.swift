import Foundation

/// Used for ensuring only valid strings are entered in a SetEntry
struct SetEntryFormatter {
    private static let MAX_CHARACTERS = 6
    
    /// Returns the given text if it is valid, otherwise returns the empty string.
    /// - Parameters:
    ///   - text: The text to validate
    ///   - inputType: The keyboard input type used to input the given text
    /// - Returns: The validated text, or the empty string
    static func validateText(text: String, inputType: KeyboardInputType) -> String {
        switch inputType {
        case .reps, .time:
            return validNumericInput(text)
        case .weight:
            return validDecimalInput(text)
        }
    }
}

// MARK: - Private

private extension SetEntryFormatter {
    
    static func validNumericInput(_ text: String) -> String {
        let numericCharacterSet = CharacterSet.decimalDigits
        let stringCharacterSet = CharacterSet(charactersIn: text)
        let isValid = numericCharacterSet.isSuperset(of: stringCharacterSet)
        
        guard isValid else { return "" }
        
        return text.count <= MAX_CHARACTERS ? text : ""
    }
    
    static func validDecimalInput(_ text: String) -> String {
        let decimalCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let stringCharacterSet = CharacterSet(charactersIn: text)
        
        let isValidCharacters = decimalCharacterSet.isSuperset(of: stringCharacterSet)
        let hasValidDecimalCount = numDecimals(text) <= 1
        let isValid = isValidCharacters && hasValidDecimalCount
        
        guard isValid else { return "" }
        
        // Add a zero if there is nothing before the decimal
        var result = text
        if text.hasPrefix(".") {
            print("got here")
            result = "0" + result
        }
        
        return result.count <= MAX_CHARACTERS ? result : ""
    }
    
    static func numDecimals(_ text: String) -> Int {
        var numDecimals = 0
        
        for char in text {
            if char == "." {
                numDecimals += 1
            }
        }
        return numDecimals
    }
}
