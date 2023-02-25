
import SwiftUI

/// Enum for different presentation heights
public enum BottomSheetSize: Hashable {
    case small
    case medium
    case large
    case percent(Double) /// Percent of screen to cover
    
    /// Determines the offset from the top of the screen that the top of the sheet should be at
    /// - Parameter containerHeight: The height of the screen
    /// - Returns: The offset from the top of the screen where the sheet starts
    func offset(containerHeight: CGFloat) -> CGFloat {
        switch self {
        case .small:
            return containerHeight * 0.8
        case .medium:
            return containerHeight * 0.5
        case .large:
            return containerHeight * 0.01
        case .percent(let percent):
            return containerHeight * (1 - percent)
        }
    }
}

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @Binding private var currentSize: BottomSheetSize
    
    private let showIndicator: Bool
    private let detents: [BottomSheetSize]
    private let sheetContent: () -> SheetContent
    
    @State private var offset: CGFloat = 0/// Offset from the top of the screen
    @State private var lastOffset: CGFloat = 0/// Last offset before current gesture
    @GestureState var gestureOffset: CGFloat = 0 /// Current offset of moving sheet
    /// Subtract height to account for Tab Bar (temporary solution)
    private let screenHeight: CGFloat = UIScreen.main.bounds.height - Layout.size(20)
    
    init(isPresented: Binding<Bool>,
         currentSize: Binding<BottomSheetSize>,
         showIndicator: Bool,
         detents: [BottomSheetSize],
         @ViewBuilder sheetContent: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self._currentSize = currentSize
        self.showIndicator = showIndicator
        self.detents = detents
        self.sheetContent = sheetContent
        /// We know that the sheet will have at least one value
        assert(detents.count > 0)
        self._offset = State(initialValue: self.currentSize.offset(containerHeight: screenHeight))
        self._lastOffset = self._offset
//        moveToClosestDetent(height: screenHeight)
    }

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                GeometryReader { _ in
                    ZStack {
                        Rectangle()
                            .fill(Color(splytColor: .white))
                            .frame(height: proxy.size.height * 1.5) // ensures rectangle is always big enough
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: Layout.size(3.5)))
                            .shadow(radius: Layout.size(0.5))
                        
                        VStack {
                            Capsule()
                                .fill(Color(splytColor: .gray).opacity(0.5))
                                .frame(width: Layout.size(9), height: Layout.size(0.5))
                                .padding(.top, Layout.size(0.5))
                                .isVisible(showIndicator)
                            sheetContent()
                            Spacer()
                        }
                    }
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .offset(y: offset)
                .gesture(drag(height: screenHeight))
                .isVisible(isPresented)
            }
        }
    }
    
    private func drag(height: CGFloat) -> some Gesture {
        DragGesture().updating($gestureOffset) { value, out, _ in
            out = value.translation.height
            Task(priority: .userInitiated) {
                await MainActor.run {
                    offset = gestureOffset + lastOffset
                }
            }
        }.onEnded { _ in
            withAnimation {
                // Controls where the sheet can be expanded/shrunk to
                moveToClosestDetent(height: height)
            }
            
            // Ensures the next gesture starts from current position and not the bottom
            lastOffset = offset
        }
    }
 
    private func moveToClosestDetent(height: CGFloat) {
        var closestDetent = detents.first!
        
        // Determines the detent that we should snap to
        detents.dropFirst().forEach { detent in
            if abs(offset - detent.offset(containerHeight: height)) <
                abs(offset - closestDetent.offset(containerHeight: height)) {
                closestDetent = detent
            }
        }
        
        offset = closestDetent.offset(containerHeight: height)
        currentSize = closestDetent
    }
}

/// Custom shape for curved edges at the top
fileprivate struct CustomCorner: Shape {
    private let corners: UIRectCorner
    private let radius: CGFloat
    
    fileprivate init(corners: UIRectCorner,
                     radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World")
            .bottomSheet(isPresented: .constant(true), currentSize: .constant(.small), detents: [.small, .medium, .percent(0.75), .large]) {
                Text("Text")
            }
    }
}
