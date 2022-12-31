
import SwiftUI

/// Makes a view scrollable only if it would exceed the screen dimensions
public extension View {
    
    /// Scrolls this view when it overflows in the given axis
    /// - Parameter axis: The axis which determines overflow (e.g. .horizontal or .vertical)
    /// - Returns: This view with the modifier applied
    func scrollOnOverflow(axis: Axis.Set) -> some View {
        modifier(OverflowContentViewModifier(axis: axis))
    }
}

// MARK: - Modifer

public struct OverflowContentViewModifier: ViewModifier {
    @State private var contentOverflow: Bool = false
    private let axis: Axis.Set
    
    public init(axis: Axis.Set) {
        self.axis = axis
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
            .background(
                GeometryReader { contentGeometry in
                    Color.clear.onAppear {
                        contentOverflow = contentGeometry.size.height > geometry.size.height
                    }
                }
            )
            .wrappedInScrollView(when: contentOverflow, axis: axis)
        }
    }
    
    
}

extension View {
    @ViewBuilder
    func wrappedInScrollView(when condition: Bool, axis: Axis.Set) -> some View {
        if condition {
            ScrollView(axis, showsIndicators: false) {
                self
            }
        } else {
            self
        }
    }
}
