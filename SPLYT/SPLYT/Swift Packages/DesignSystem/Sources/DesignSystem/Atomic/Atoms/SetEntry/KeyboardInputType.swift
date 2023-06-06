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
//    /// Formats the value to be the properly formatted string.
//    var getString: String {
//        switch self {
//        case .reps(let reps):
//            guard let reps = reps else { return "" }
//            return String(reps)
//        case .weight(let weight):
//            guard let weight = weight else { return "" }
//
//            if weight.remainder(dividingBy: 1) == 0 {
//                // If there is nothing after the decimal, get rid of it
//                let formatter = NumberFormatter()
//                formatter.minimumFractionDigits = 0
//                return formatter.string(from: NSNumber(value: weight)) ?? String(weight)
//            }
//
//            return String(weight)
//        case .time(let seconds):
//            guard let seconds = seconds else { return "" }
//            return String(seconds)
//        }
//    }
}
