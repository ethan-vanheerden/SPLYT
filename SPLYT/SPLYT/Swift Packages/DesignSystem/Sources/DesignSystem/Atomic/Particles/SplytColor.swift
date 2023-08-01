import SwiftUI

public enum SplytColor: String, CaseIterable {
    case black = "Black"
    case gray = "Gray"
    case gray50 = "Gray 50"
    case green = "Green"
    case lightBlue = "Light Blue"
    case red = "Red"
    case white = "White"
    case yellow = "Yellow"
    case clear = "Clear"
    case purple = "Purple"
    case blue = "Blue"
    
    public var color: Color {
        switch self {
        case .black:
            return Color.black
        case .gray:
            return Color.gray
        case .gray50:
            return Color.gray.opacity(0.5)
        case .green:
            return Color.green
        case .lightBlue:
            return Color(uiColor: UIColor(red: 104/255,
                                          green: 172/255,
                                          blue: 252/255,
                                          alpha: 1))
        case .red:
            return Color.red
        case .white:
            return Color.white
        case .yellow:
            return Color.yellow
        case .clear:
            return Color.clear
        case .purple:
            return Color(uiColor: UIColor(red: 42/255,
                                          green: 0,
                                          blue: 254/255,
                                          alpha: 1))
        case .blue:
            return Color.blue
        }
    }
    
    public func opacity(_ opacity: Double) -> Color {
        return self.color.opacity(opacity)
    }
}
