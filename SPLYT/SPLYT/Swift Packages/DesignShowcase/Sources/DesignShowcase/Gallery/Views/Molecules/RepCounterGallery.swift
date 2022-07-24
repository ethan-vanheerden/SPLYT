import SwiftUI
import DesignSystem

struct RepCounterGallery: View {
    @State private var firstNumber = 8
    @State private var secondNumber = 0
    var body: some View {
        VStack {
            Spacer()
            RepCounter(selectedNumber: $firstNumber)
            Text("First number: \(firstNumber)")
            
            RepCounter(selectedNumber: $secondNumber)
            Text("Second number: \(secondNumber)")
            Spacer()
        }
    }
}
