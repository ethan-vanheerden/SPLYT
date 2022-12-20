
import SwiftUI

public struct FABIcon: View {
    private let type: FABIconType
    
    public init(type: FABIconType) {
        self.type = type
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(circleColor.shadow(.drop(radius: Layout.size(2))))
                .frame(width: circleSize)
            Image(systemName: type.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
                .foregroundColor(iconColor)
        }
    }
    
    private var circleColor: Color {
        switch type.size {
        case .primary:
            return SplytColor.lightBlue
        case .secondary:
            return Color.white
        }
    }
    
    private var circleSize: CGFloat {
        switch type.size {
        case .primary:
            return Layout.size(8)
        case .secondary:
            return Layout.size(4)
        }
    }
    
    private var iconColor: Color {
        switch type.size {
        case .primary:
            return Color.white
        case .secondary:
            return SplytColor.lightBlue
        }
    }
    
    private var iconSize: CGFloat {
        switch type.size {
        case .primary:
            return Layout.size(2.5)
        case .secondary:
            return Layout.size(2)
        }
    }
}

struct FABIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Layout.size(6)) {
            FABIcon(type: FABIconType(size: .primary, imageName: "plus"))
            FABIcon(type: FABIconType(size: .secondary, imageName: "calendar"))
        }
    }
}

public struct FABIconType {
    let size: FABIconSize
    let imageName: String
    
    public init(size: FABIconSize,
                imageName: String) {
        self.size = size
        self.imageName = imageName
    }
}

public enum FABIconSize {
    case primary
    case secondary
}
