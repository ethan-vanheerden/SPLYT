import SwiftUI

public enum SplytColor: String, CaseIterable {
    case black = "Black"
    case gray = "Gray"
    case gray50 = "Gray 50"
    case green = "Green"
    case forestGreen = "Forest Green"
    case lightBlue = "Light Blue"
    case red = "Red"
    case red50 = "Red 50"
    case white = "White"
    case yellow = "Yellow"
    case clear = "Clear"
    case darkBlue = "Dark Blue"
    case blue = "Blue"
    case purple = "Purple"
    case pink = "Pink"
    case orange = "Orange"
    case mint = "Mint"
    case label = "Label"
    case background = "Background"
    case shadow = "Shadow"
    
    public var color: Color {
        switch self {
        case .black:
            return Color("Black")
        case .gray:
            return Color("Gray")
        case .gray50:
            return Color("Gray50")
        case .green:
            return Color("Green")
        case .forestGreen:
            return Color("ForestGreen")
        case .lightBlue:
            return Color("LightBlue")
        case .red:
            return Color("Red")
        case .red50:
            return Color("Red50")
        case .white:
            return Color("White")
        case .yellow:
            return Color("Yellow")
        case .clear:
            return Color.clear
        case .darkBlue:
            return Color("DarkBlue")
        case .blue:
            return Color("Blue")
        case .purple:
            return Color("Purple")
        case .pink:
            return Color("Pink")
        case .orange:
            return Color("Orange")
        case .mint:
            return Color("Mint")
        case .label:
            return Color("Label")
        case .background:
            return Color("Background")
        case .shadow:
            return Color("Shadow")
        }
    }
    
    public func opacity(_ opacity: Double) -> Color {
        return self.color.opacity(opacity)
    }
    
    public static var userThemes: [SplytColor] {
        return [
            .red,
            .pink,
            .orange,
            .yellow,
            .green,
            .forestGreen,
            .mint,
            .blue,
            .darkBlue,
            .purple
        ]
    }
}
