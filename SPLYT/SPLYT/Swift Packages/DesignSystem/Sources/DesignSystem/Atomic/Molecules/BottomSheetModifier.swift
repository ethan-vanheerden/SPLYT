
import SwiftUI

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    
    @Binding private var isPresented: Bool
    private let detents: Set<PresentationDetent>
    private let sheetContent: () -> SheetContent
    
    init(isPresented: Binding<Bool>,
         detents: Set<PresentationDetent>,
         @ViewBuilder sheetContent: @escaping () -> SheetContent) {
        self._isPresented = isPresented
        self.detents = detents
        self.sheetContent = sheetContent
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .presentationDetents(detents)
            }
            .unredacted()
    }
}
