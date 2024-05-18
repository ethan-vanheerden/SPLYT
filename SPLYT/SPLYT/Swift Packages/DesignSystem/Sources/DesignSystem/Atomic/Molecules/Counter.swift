import SwiftUI

public struct Counter: View {
    @Binding private var selectedNumber: Int
    @State private var selectedNumberText: String = ""
    @FocusState private var fieldFocused
    @EnvironmentObject private var userTheme: UserTheme
    private let viewState: CounterViewState
    private let sideLength: CGFloat = Layout.size(5)
    
    public init(selectedNumber: Binding<Int>,
                viewState: CounterViewState) {
        self._selectedNumber = selectedNumber
        self._selectedNumberText = State(initialValue: "\(selectedNumber.wrappedValue)")
        self.viewState = viewState
    }
    
    public var body: some View {
        VStack(spacing: Layout.size(0.25)) {
            HStack {
                minusButton
                selection
                plusButton
            }
            Text(viewState.label)
                .footnote()
        }
        .onTapGesture {
            if fieldFocused {
                fieldFocused = false
            }
        }
    }
    
    @ViewBuilder
    private var minusButton: some View {
        IconButton(iconName: "minus",
                   style: .secondary,
                   iconColor: .black,
                   isEnabled: selectedNumber > viewState.minNumber) {
            selectedNumber -= 1
        }
    }
    
    @ViewBuilder
    private var plusButton: some View {
        IconButton(iconName: "plus",
                   style: .secondary,
                   iconColor: .black,
                   isEnabled: selectedNumber < viewState.maxNumber) {
            selectedNumber += 1
        }
    }
    
    @ViewBuilder
    private var selection: some View {
        TextField("", text: textFieldBinding)
            .keyboardType(.numberPad)
            .textFieldStyle(.plain)
            .focused($fieldFocused)
            .multilineTextAlignment(.center)
            .font(Font.custom("Montserrat-SemiBold", size: 13))
            .foregroundColor(Color(splytColor: viewState.textColor ?? .white))
            .frame(width: sideLength, height: sideLength)
            .roundedBackground(cornerRadius: Layout.size(1),
                               fill: Color(splytColor: viewState.backGroundColor ?? userTheme.theme)
                .shadow(.drop(radius: Layout.size(0.5))))
    }
    
    private func intValue(newValue: String) -> Int? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: newValue)?.intValue
    }
    
    private var textFieldBinding: Binding<String> {
        return Binding(
            get: { return "\(selectedNumber)"},
            set: { newValue in
                guard let intValue = intValue(newValue: newValue),
                      intValue <= viewState.maxNumber,
                      intValue >= viewState.minNumber else { return }
                selectedNumber = intValue
            }
        )
    }
}

// MARK: - View State

public struct CounterViewState: Equatable {
    fileprivate let maxNumber: Int
    fileprivate let minNumber: Int
    fileprivate let label: String
    fileprivate let backGroundColor: SplytColor?
    fileprivate let textColor: SplytColor?
    
    public init(maxNumber: Int,
                minNumber: Int = 0,
                label: String,
                backGroundColor: SplytColor? = nil,
                textColor: SplytColor? = nil) {
        self.maxNumber = maxNumber
        self.minNumber = minNumber
        self.label = label
        self.backGroundColor = backGroundColor
        self.textColor = textColor
    }
}
