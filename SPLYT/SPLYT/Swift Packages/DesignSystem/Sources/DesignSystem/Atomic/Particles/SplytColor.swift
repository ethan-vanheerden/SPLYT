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
        case .forestGreen:
            return Color(uiColor: UIColor(red: 48/255,
                                          green: 69/255,
                                          blue: 41/255,
                                          alpha: 1))
        case .lightBlue:
            return Color(uiColor: UIColor(red: 104/255,
                                          green: 172/255,
                                          blue: 252/255,
                                          alpha: 1))
        case .red:
            return Color.red
        case .red50:
            return Color.red.opacity(0.5)
        case .white:
            return Color.white
        case .yellow:
            return Color.yellow
        case .clear:
            return Color.clear
        case .darkBlue:
            return Color(uiColor: UIColor(red: 42/255,
                                          green: 0,
                                          blue: 254/255,
                                          alpha: 1))
        case .blue:
            return Color.blue
        case .purple:
            return Color.purple
        case .pink:
            return Color(uiColor: UIColor(red: 252/255,
                                                 green: 142/255,
                                                 blue: 172/255,
                                                 alpha: 1))
        case .orange:
            return Color.orange
        case .mint:
            return Color.mint
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
