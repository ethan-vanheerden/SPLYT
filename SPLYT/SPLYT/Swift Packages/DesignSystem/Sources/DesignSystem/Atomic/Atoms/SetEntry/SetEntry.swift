import SwiftUI
import ExerciseCore

public struct SetEntry: View {
    @Binding private var input: String // Binding so that the text can be updated via a view model
    private let title: String
    private let keyboardType: KeyboardInputType
    private let placeholder: String?
    private let tag: Int
    
    public init(input: Binding<String>,
                title: String,
                keyboardType: KeyboardInputType,
                placeholder: String? = nil,
                tag: Int) {
        self._input = input
        self.title = title
        self.keyboardType = keyboardType
        self.placeholder = placeholder
        self.tag = tag
    }
    
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                SetEntryTextField(text: $input,
                                  placeholder: placeholder,
                                  keyboardType: keyboardType,
                                  tag: tag)
                .shadow(radius: Layout.size(0.125))
                .frame(width: Layout.size(8))
                .fixedSize()
            }
            Text(title)
                .footnote()
                .foregroundColor(Color(splytColor: .gray))
                .padding(.top, Layout.size(-0.75)) // Because of automatic padding on TextField
            Spacer()
        }
        .frame(width: Layout.size(8), height: Layout.size(8))
    }
}
