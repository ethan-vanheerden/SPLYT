
import SwiftUI
import DesignSystem

struct BottomSheetGallery: View {
    @State private var sheetOnePresented = false
    @State private var sheetTwoPresented = false
    private let sheetTwoDetents: [BottomSheetSize] = [.percent(0.1), .small, .medium, .large]
    
    var body: some View {
        VStack {
            Spacer()
            SplytButton(text: "Present Sheet One") {
                sheetOnePresented.toggle()
            }
            .padding(.bottom)
            
            SplytButton(text: "Present Sheet Two") {
                sheetTwoPresented.toggle()
            }
            Spacer()
        }
        .bottomSheet(isPresented: $sheetOnePresented, currentSize: .constant(.small), showIndicator: false) {
            Text("Sheet One")
        }
        .bottomSheet(isPresented: $sheetTwoPresented, currentSize: .constant(.small), detents: sheetTwoDetents) {
            Text("Sheet Two")
        }
    }
}
