import SwiftUI

public struct SetEntry: View {
    @State private var text: String = ""
    @FocusState private var fieldFocused: Bool
    private let id: AnyHashable
    private let title: String
    private let placeholder: String?
    private let inputType: SetEntryType
    // AnyHashable to represent the setId, Double to represent the new value
    private let doneAction: (AnyHashable, Double) -> Void
    
    public init(id: AnyHashable,
                title: String,
                placeholder: String? = nil,
                inputType: SetEntryType,
                doneAction: @escaping (AnyHashable, Double) -> Void) {
        self.id = id
        self.title = title
        self.placeholder = placeholder
        self.inputType = inputType
        self.doneAction = doneAction
    }
    
    public var body: some View {
        NavigationStack { // Need to wrap in a NavigationStack for iOS bug with duplicated "Done" buttons
            VStack {
                Spacer()
                HStack {
                    TextField(placeholder ?? "", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(keyboardType)
                        .multilineTextAlignment(.center)
                        .focused($fieldFocused)
                        .minimumScaleFactor(0.8)
                        .font(Font.system(size: 14, design: .default))
                        .frame(width: Layout.size(7))
                }
                Text(title)
                    .bodyText()
                    .foregroundColor(Color.splytColor(.gray))
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
                    doneAction(id, value)
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
        case .weight:
            return .decimalPad
        case .reps:
            return .numberPad
        }
    }
}

// MARK: - Input Type

public enum SetEntryType {
    case weight
    case reps
}
