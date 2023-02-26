import SwiftUI

public struct FABIcon: View {
    private let type: FABIconType
    private let tapAction: () -> Void
    @State private var isPressed = false
    
    public init(type: FABIconType,
                tapAction: @escaping () -> Void) {
        self.type = type
        self.tapAction = tapAction
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
        .gesture(press)
        .frame(width: circleFrame, height: circleFrame)
    }
    
    /// Animates FAB and changes color on tap
    // TODO: add vibration effect
    private var press: some Gesture {
        DragGesture(minimumDistance: .zero)
            .onChanged { _ in
                withAnimation {
                    isPressed = true
                }
            }
            .onEnded { _ in
                tapAction()
                withAnimation {
                    isPressed = false
                }
            }
    }
    
    private var circleFrame: CGFloat {
        switch type.size {
        case .primary:
            return Layout.size(8)
        case .secondary:
            return Layout.size(4)
        }
    }
    
    private var circleColor: Color {
        switch type.size {
        case .primary:
            return Color(splytColor: .lightBlue)
        case .secondary:
            return Color(splytColor: .white)
        }
    }
    
    private var circleSize: CGFloat {
        switch type.size {
        case .primary:
            return isPressed ? Layout.size(7) : Layout.size(8)
        case .secondary:
            return isPressed ? Layout.size(3.5) : Layout.size(4)
        }
    }
    
    private var iconColor: Color {
        switch type.size {
        case .primary:
            return Color(splytColor: .white)
        case .secondary:
            return Color(splytColor: .lightBlue)
        }
    }
    
    private var iconSize: CGFloat {
        switch type.size {
        case .primary:
            return isPressed ? Layout.size(2.2) : Layout.size(2.5)
        case .secondary:
            return isPressed ? Layout.size(1.75) : Layout.size(2)
        }
    }
}

struct FABIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Layout.size(6)) {
            FABIcon(type: FABIconType(size: .primary, imageName: "plus"),
                    tapAction: {})
            FABIcon(type: FABIconType(size: .secondary, imageName: "calendar"),
                    tapAction: {})
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
