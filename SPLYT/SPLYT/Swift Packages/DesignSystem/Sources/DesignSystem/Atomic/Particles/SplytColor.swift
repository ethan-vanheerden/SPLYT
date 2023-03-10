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
            return Color(uiColor: UIColor(red: 104/255, green: 172/255, blue: 252/255, alpha: 1.0))
        case .red:
            return Color.red
        case .white:
            return Color.white
        case .yellow:
            return Color.yellow
        }
    }
}
