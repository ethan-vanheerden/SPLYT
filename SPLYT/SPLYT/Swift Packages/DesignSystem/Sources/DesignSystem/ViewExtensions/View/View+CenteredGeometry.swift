import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Centers this view when it is used in a `GeometryReader` because `GeometryReader`s have weird behavior.
    /// - Parameter proxy: The proxy for the view's space
    /// - Returns: This view centered in it's geometry space
    func centerGeometry(proxy: GeometryProxy) -> some View {
        self.position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
    }
}
