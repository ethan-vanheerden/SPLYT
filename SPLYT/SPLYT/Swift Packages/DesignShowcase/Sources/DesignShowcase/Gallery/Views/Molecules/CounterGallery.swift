import SwiftUI
import DesignSystem

struct CounterGallery: View {
    @State private var firstNumber = 8
    @State private var secondNumber = 0
    private let viewStateOne = CounterViewState(maxNumber: 60,
                                                label: "min",
                                                backGroundColor: .lightBlue,
                                                textColor: .black)
    private let viewStateTwo = CounterViewState(maxNumber: 10,
                                                minNumber: -10,
                                                label: "sec",
                                                backGroundColor: .darkBlue,
                                                textColor: .white)
    
    var body: some View {
        VStack {
            Spacer()
            Counter(selectedNumber: $firstNumber,
                    viewState: viewStateOne)
            Text("First number: \(firstNumber)")
            
            Counter(selectedNumber: $secondNumber,
                    viewState: viewStateTwo)
            Text("Second number: \(secondNumber)")
            Spacer()
        }
    }
}
