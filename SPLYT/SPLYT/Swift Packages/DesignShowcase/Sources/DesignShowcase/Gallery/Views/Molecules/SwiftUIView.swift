
import SwiftUI
import DesignSystem

struct BottomSheetGallery: View {
    @State private var sheetOnePresented = false
    @State private var sheetTwoPresented = false
    private let sheetTwoDetents: Set<PresentationDetent> = [.fraction(0.1), .medium, .large]
    
    var body: some View {
        VStack {
            Spacer()
            Button("Present Sheet One") {
                sheetOnePresented = true
            }
            .padding(.bottom)
            
            Button("Present Sheet Two") {
                sheetTwoPresented = true
            }
            Spacer()
        }
        .bottomSheet(isPresented: $sheetOnePresented) {
            Text("Sheet One")
        }
        .bottomSheet(isPresented: $sheetTwoPresented, detents: sheetTwoDetents) {
            Text("Sheet Two")
        }
    }
}
