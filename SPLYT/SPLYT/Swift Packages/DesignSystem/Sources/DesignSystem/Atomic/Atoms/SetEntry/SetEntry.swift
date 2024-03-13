import SwiftUI
import ExerciseCore
import SwiftUIIntrospect

public struct SetEntry: View {
    @FocusState private var fieldFocused: Bool
    @State private var input: String // Binding so that the text can be updated via a view model
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
                        // Ensures we only send an update event once the user finishes typing
                        print("isFocused: \(isFocused)")
                        if !isFocused {
                            let validText = SetEntryFormatter.validateText(text: input, inputType: keyboardType)
                            input = validText
                            updateAction(validText)
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
    
    private var borderColor: SplytColor {
        return fieldFocused ? .lightBlue : .gray
    }
    
    private var shadowRadius: CGFloat? {
        return fieldFocused ? Layout.size(0.25) : nil
    }
}
