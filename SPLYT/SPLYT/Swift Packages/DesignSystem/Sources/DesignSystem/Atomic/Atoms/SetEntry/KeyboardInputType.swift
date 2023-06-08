import Foundation
import UIKit

enum KeyboardInputType {
    case reps
    case weight
    case time
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .reps, .time:
            return .numberPad
        case .weight:
            return .decimalPad
        }
    }
}
