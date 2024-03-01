import Foundation
import SwiftUI

struct SetEntryTextField: UIViewRepresentable {
    @State private var isFocused: Bool = false
    @Binding private var text: String
    private let placeholder: String?
    private let keyboardType: KeyboardInputType
    private let maxCharacters = 6
    
    init(text: Binding<String>,
         placeholder: String?,
         keyboardType: KeyboardInputType) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType.keyboardType
        textField.font = UIFont(name: "Montserrat-Regular", size: 14)
        textField.textAlignment = .center
        textField.minimumFontSize = 10
        textField.adjustsFontSizeToFitWidth = true
        
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = Layout.size(0.5)
        
        textField.widthAnchor.constraint(equalToConstant: Layout.size(8)).isActive = true
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // For changing the outline color when focused
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidEndEditing(_:)), for: .editingDidEnd)
        
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done",
                                   style: .done,
                                   target: context.coordinator,
                                   action: #selector(Coordinator.dismissKeyboard))
        
        toolbar.setItems([flexSpace, done], animated: true)
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.layer.borderColor = isFocused ? Color(splytColor: .lightBlue).cgColor : Color(uiColor: .gray).cgColor
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    // MARK: - Coordinator
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        private let parent: SetEntryTextField
        
        init(parent: SetEntryTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let currentText = textField.text else { return true }
            
            let validInput: Bool
            switch parent.keyboardType {
            case .reps, .time:
                validInput =  isValidNumericInput(string)
            case .weight:
                validInput = isValidDecimalInput(currentText, string)
            }
            
            let newLength = currentText.count + string.count - range.length
            
            return (newLength <= parent.maxCharacters) && validInput
        }
        
        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        @objc func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true
        }
        
        @objc func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false
        }
        
        private func isValidNumericInput(_ string: String) -> Bool {
            let numericCharacterSet = CharacterSet.decimalDigits
            let stringCharacterSet = CharacterSet(charactersIn: string)
            
            return numericCharacterSet.isSuperset(of: stringCharacterSet)
        }
        
        private func isValidDecimalInput(_ currentText: String, _ string: String) -> Bool {
            let decimalCharacterSet = CharacterSet(charactersIn: "0123456789.")
            let stringCharacterSet = CharacterSet(charactersIn: string)
            
            let isValidCharacters = decimalCharacterSet.isSuperset(of: stringCharacterSet)
            
            let numDecimalsCurrent = numDecimals(currentText)
            let numDecimalsNew = numDecimals(string)
            let hasValidDecimalCount = !(numDecimalsCurrent >= 1 && numDecimalsNew >= 1)
            
            return isValidCharacters && hasValidDecimalCount
        }
        
        private func numDecimals(_ text: String) -> Int {
            var numDecimals = 0
            
            for char in text {
                if char == "." {
                    numDecimals += 1
                }
            }
            return numDecimals
        }
    }
}
