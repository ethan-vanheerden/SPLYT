import SwiftUI

public enum SplytGradient: String, CaseIterable {
    case classic = "Classic"
    
    public func gradient(startPoint: UnitPoint = .bottomLeading,
                         endPoint: UnitPoint = .topTrailing) -> LinearGradient {
        switch self {
        case .classic:
            return LinearGradient(colors: [Color(splytColor: .blue), Color(splytColor: .darkBlue)],
                                  startPoint: startPoint,
                                  endPoint: endPoint)
        }
    }
}
