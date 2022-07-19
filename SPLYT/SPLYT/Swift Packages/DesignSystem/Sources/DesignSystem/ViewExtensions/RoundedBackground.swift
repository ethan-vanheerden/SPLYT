import SwiftUI

public extension View {
    func roundedBackground<S: ShapeStyle>(cornerRadius: CGFloat, fill: S) -> some View {
        return self.background(RoundedRectangle(cornerRadius: cornerRadius).fill(fill))
    }
}
