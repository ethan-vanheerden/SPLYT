import SwiftUI
import ExerciseCore
import SwiftUIIntrospect

public struct SetEntry: View {
    @FocusState private var fieldFocused: Bool
    @State private var input: String // Binding so that the text can be updated via a view model
    @EnvironmentObject private var userTheme: UserTheme
    private let tagCounter = TagCounter.shared
    private let title: String
    private let keyboardType: KeyboardInputType
    private let placeholder: String?
    private let updateAction: (String) -> Void
    
    public init(input: String,
                title: String,
                keyboardType: KeyboardInputType,
                placeholder: String? = nil,
                updateAction: @escaping (String) -> Void) {
        self._input = State(initialValue: input)
        self.title = title
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.updateAction = updateAction
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                // First parameter is for a placeholder
                TextField(placeholder ?? "", text: $input)
                    .introspect(.textField, on: .iOS(.v15, .v16, .v17)) { textField in
                        // Using this library to avoid duplicate done button issue
                        let toolbar = UIToolbar()
                        let done = UIBarButtonItem(title: "Done",
                                                   style: .done,
                                                   target: textField,
                                                   action: #selector(UIResponder.resignFirstResponder))
                        
                        toolbar.setItems([.flexibleSpace(), done], animated: true)
                        toolbar.sizeToFit()
                        textField.inputAccessoryView = toolbar
                    }
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(keyboardType.keyboardType)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocused)
                    .minimumScaleFactor(0.8)
                    .font(Font.system(size: 14, design: .default))
                    .strokeBorder(cornerRadius: Layout.size(1), color: borderColor, shadowRadius: shadowRadius)
                    .onChange(of: fieldFocused) { isFocused in
                        if !isFocused {
                            sendUpdate(newInput: input)
                        }
                    }
                    .onChange(of: input) { newInput in
                        // Formatter would otherwise remove a decimal right when it is added
                        if !newInput.hasSuffix(".") {
                            sendUpdate(newInput: input)
                        }
                    }
            }
            Text(title)
                .footnote()
                .foregroundColor(Color(splytColor: .gray))
                .padding(.top, Layout.size(-0.75)) // Because of automatic padding on TextField
            Spacer()
        }
        .frame(width: Layout.size(8), height: Layout.size(8))
        .onTapGesture {
            // Dismiss keyboard if we tap again
            if fieldFocused {
                fieldFocused = false
            }
        }
    }
    
    private func sendUpdate(newInput: String) {
        let validText = SetEntryFormatter.validateText(text: newInput, inputType: keyboardType)
        input = validText
        updateAction(validText)
    }
    
    private var borderColor: SplytColor {
        return fieldFocused ? userTheme.theme : .gray
    }
    
    private var shadowRadius: CGFloat? {
        return fieldFocused ? Layout.size(0.25) : nil
    }
}
