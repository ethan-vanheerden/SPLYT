import SwiftUI

public enum SplytColor: String, CaseIterable {
    case black = "Black"
    case gray = "Gray"
    case green = "Green"
    case lightBlue = "Light Blue"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
    
    public var color: Color {
        switch self {
        case .black:
            return Color.black
        case .gray:
            return Color.gray
        case .green:
            return Color.green
        case .lightBlue:
            return Color.blue.opacity(0.6)
        case .red:
            return Color.red
        case .white:
            return Color.white
        case .yellow:
            return Color.yellow
        }
    }
}


public extension Color {
    static func splytColor(_ color: SplytColor) -> Color {
        return color.color
    }
}
