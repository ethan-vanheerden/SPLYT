
import SwiftUI
import ExerciseCore

struct SetEntry: View {
    @FocusState private var fieldFocused: Bool
    @Binding private var input: String // Binding so that the text can be updated via a view model
    private let title: String
    private let keyboardType: KeyboardInputType
    private let placeholder: String?
    
    init(input: Binding<String>,
         title: String,
         keyboardType: KeyboardInputType,
         placeholder: String? = nil) {
        self._input = input
        self.title = title
        self.keyboardType = keyboardType
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // First parameter is for a placeholder
                TextField(placeholder ?? "", text: $input)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(keyboardType.keyboardType)
                    .multilineTextAlignment(.center)
                    .focused($fieldFocused)
                    .minimumScaleFactor(0.8)
                    .font(Font.system(size: 14, design: .default))
                    .strokeBorder(cornerRadius: Layout.size(1), color: borderColor, shadowRadius: shadowRadius)
            }
            Text(title)
                .footnote()
                .foregroundColor(Color(splytColor: .gray))
                .padding(.top, Layout.size(-0.75)) // Because of automatic padding on TextField
            Spacer()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    fieldFocused = false
                }
            }
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
