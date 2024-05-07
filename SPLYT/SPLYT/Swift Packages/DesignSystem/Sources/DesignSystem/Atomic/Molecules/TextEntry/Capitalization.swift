import Foundation
import SwiftUI

public enum Capitalization {
    case never
    case firstWord
    case everyWord
    case everyLetter
    
    var toSwiftUI: TextInputAutocapitalization {
        switch self {
        case .never:
            return .never
        case .firstWord:
            return .sentences
        case .everyWord:
            return .words
        case .everyLetter:
            return .characters
        }
    }
}
