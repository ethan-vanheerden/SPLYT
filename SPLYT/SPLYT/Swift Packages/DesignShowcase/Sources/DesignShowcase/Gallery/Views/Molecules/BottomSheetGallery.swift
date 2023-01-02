
import SwiftUI
import DesignSystem

struct BottomSheetGallery: View {
    @State private var sheetOnePresented = false
    @State private var sheetTwoPresented = false
    private let sheetTwoDetents: [BottomSheetSize] = [.percent(0.1), .small, .medium, .large]
    
    var body: some View {
        VStack {
            Spacer()
            Button("Present Sheet One") {
                sheetOnePresented.toggle()
            }
            .padding(.bottom)
            
            Button("Present Sheet Two") {
                sheetTwoPresented.toggle()
            }
            Spacer()
        }
        .bottomSheet(isPresented: $sheetOnePresented, showIndicator: false) {
            Text("Sheet One")
        }
        .bottomSheet(isPresented: $sheetTwoPresented, detents: sheetTwoDetents) {
            Text("Sheet Two")
        }
    }
}
