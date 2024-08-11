import SwiftUI

public enum SplytGradient: String, CaseIterable {
    case classic = "Classic"
    
    public func gradient(startPoint: UnitPoint = .bottomLeading,
                         endPoint: UnitPoint = .topTrailing) -> LinearGradient {
        switch self {
        case .classic:
            return LinearGradient(colors: [Color(SplytColor.blue), Color(SplytColor.darkBlue)],
                                  startPoint: startPoint,
                                  endPoint: endPoint)
        }
    }
}
