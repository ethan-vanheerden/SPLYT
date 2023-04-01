
import SwiftUI
import ExerciseCore

struct SetEntry: View {
    @State private var text: String = ""
    @FocusState private var fieldFocused: Bool
    private let title: String
    private let placeholder: String
    private let inputType: InputType
    // We use a Double to represent the changed value of the entry (we cast it to its expected type later)
    private let updateAction: (Double) -> Void
    
    init(title: String,
         startingInput: String? = nil,
         inputType: InputType,
         updateAction: @escaping (Double) -> Void) {
        self.title = title
        self.inputType = inputType
        self.placeholder = inputType.getString
        self.updateAction = updateAction
        
        if let startingInput = startingInput {
            self._text = State(initialValue: startingInput)
        }
    }
    
    var body: some View {
        NavigationStack { // Need to wrap in a NavigationStack for iOS bug with duplicated "Done" buttons
            VStack {
                Spacer()
                HStack {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.center)
                        .focused($fieldFocused)
                        .minimumScaleFactor(0.8)
                        .font(Font.system(size: 14, design: .default))
                        .frame(width: Layout.size(7))
                }
                Text(title)
                    .footnote()
                    .foregroundColor(Color(splytColor: .gray))
                    .padding(.top, Layout.size(-0.75)) // Because of automatic padding on TextField
                Spacer()
            }
            .onChange(of: text) { _ in
                validateText()
            }
            .onChange(of: fieldFocused) { isFocused in
                // If we lose focus, do the action
                if !isFocused,
                   let value = value {
                    updateAction(value)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        fieldFocused = false
                    }
                }
            }
        }
        .frame(width: Layout.size(7), height: Layout.size(8))
    }
    
    private var value: Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: text)?.doubleValue
    }
    
    /// Ensures we only update the text field if the user entered a valid number
    private func validateText() {
        guard let _ = value else {
            text = ""
            return
        }
    }
    
    private var keyboardType: UIKeyboardType {
        switch inputType {
        case .reps, .time:
            return .numberPad
        case .weight:
            return .decimalPad
        }
    }
}
