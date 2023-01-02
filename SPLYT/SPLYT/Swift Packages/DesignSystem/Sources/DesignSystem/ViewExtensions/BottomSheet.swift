
import SwiftUI

public extension View {
    
    /// Presents a bottom sheet conditionally over a view. Note that user interactions are still enabled on views below the sheet.
    /// - Parameters:
    ///   - isPresented: Binding to show the sheet
    ///   - showIndicator: Whether or not to show the drag indicator
    ///   - detents: The supported sizes that the bottom sheet will "snap to"
    ///   - sheetContent: The view inside of the sheet
    /// - Returns: The view with the bottom sheet
    func bottomSheet<Content: View>(isPresented: Binding<Bool>,
                                    showIndicator: Bool = true,
                                    detents: [BottomSheetSize] = [.medium],
                                    @ViewBuilder sheetContent: @escaping () -> Content) -> some View {
        modifier(BottomSheetModifier(isPresented: isPresented,
                                     showIndicator: showIndicator,
                                     detents: detents,
                                     sheetContent: sheetContent))
    }
}
