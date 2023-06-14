import SwiftUI

public extension View {
    /// Allows this view to be collapsed/expanded with an animation.
    /// - Parameter isExpanded: Binding to whether or not this view should be shown
    /// - Returns: This view with the collapse modifier attached
    func collapsible(isExpanded: Binding<Bool>) -> some View {
        modifier(CollapseModifier(isExpanded: isExpanded))
    }
}

// MARK: - Modifier

struct CollapseModifier: ViewModifier {
    @State private var contentHeight: CGFloat = 0
    @Binding private var isExpanded: Bool
    
    init(isExpanded: Binding<Bool>) {
        self._isExpanded = isExpanded
    }
    
    // Inspiration taken from https://www.fivestars.blog/articles/swiftui-share-layout-information/
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
                }
            )
            .onPreferenceChange(HeightPreferenceKey.self) { newHeight in
                // This step ensures we only expand as much as we need to
                contentHeight = newHeight
            }
            .frame(height: isExpanded ? contentHeight : 0, alignment: .top)
            .clipped()
    }
}

// MARK: - Height Preference Key

/// This allows child views to update a key so that a parent view can subscribe to that key being changed
struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
