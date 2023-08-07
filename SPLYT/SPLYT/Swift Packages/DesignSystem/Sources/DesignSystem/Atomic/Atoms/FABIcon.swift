import SwiftUI

public struct FABIcon: View {
    @State private var isPressed = false
    private let viewState: FABIconViewState
    private let tapAction: () -> Void
    
    public init(viewState: FABIconViewState,
                tapAction: @escaping () -> Void) {
        self.viewState = viewState
        self.tapAction = tapAction
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .fill(Color(splytColor: viewState.size.backgroundColor)
                    .shadow(.drop(radius: Layout.size(1))))
                .frame(width: circleSize)
            Image(systemName: viewState.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: iconSize)
                .foregroundColor(Color(splytColor: viewState.size.iconColor))
        }
        .gesture(press)
        .frame(width: circleFrame, height: circleFrame)
    }
    
    /// Animates FAB and changes size on tap
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
        switch viewState.size {
        case .primary:
            return Layout.size(8)
        case .secondary:
            return Layout.size(4)
        }
    }
    
    private var circleSize: CGFloat {
        switch viewState.size {
        case .primary:
            return isPressed ? Layout.size(7) : Layout.size(8)
        case .secondary:
            return isPressed ? Layout.size(3.5) : Layout.size(4)
        }
    }
    
    private var iconSize: CGFloat {
        switch viewState.size {
        case .primary:
            return isPressed ? Layout.size(2.2) : Layout.size(2.5)
        case .secondary:
            return isPressed ? Layout.size(1.75) : Layout.size(2)
        }
    }
}

// MARK: - View State

public struct FABIconViewState: Equatable {
    let size: FABIconSize
    let imageName: String
    
    public init(size: FABIconSize,
                imageName: String) {
        self.size = size
        self.imageName = imageName
    }
}

// MARK: - Size

public enum FABIconSize: Equatable {
    case primary(backgroundColor: SplytColor, iconColor: SplytColor)
    case secondary(backgroundColor: SplytColor, iconColor: SplytColor)
    
    var backgroundColor: SplytColor {
        switch self {
        case let .primary(color, _),
            let .secondary(color, _):
            return color
        }
    }
    
    var iconColor: SplytColor {
        switch self {
        case let .primary(_, color),
            let .secondary(_, color):
            return color
        }
    }
}
