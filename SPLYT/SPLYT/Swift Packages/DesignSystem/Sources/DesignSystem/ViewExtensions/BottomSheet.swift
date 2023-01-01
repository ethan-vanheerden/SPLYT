
import SwiftUI

/// Makes a view scrollable only if it would exceed the screen dimensions
public extension View {
    
    func bottomSheet<Content: View>(isPresented: Binding<Bool>,
                                    detents: Set<PresentationDetent> = [.medium],
                                    @ViewBuilder sheetContent: @escaping () -> Content) -> some View {
        modifier(BottomSheetModifier(isPresented: isPresented, detents: detents, sheetContent: sheetContent))
    }
}
