import SwiftUI

public struct TextEntry: View {
    @FocusState private var isFocused: Bool
    @Binding private var text: String
    private let viewState: TextEntryViewState
    
    public init(text: Binding<String>,
                viewState: TextEntryViewState) {
        self._text = text
        self.viewState = viewState
    }
    
    public var body: some View {
        VStack {
            if let title = viewState.title {
                HStack {
                    Text(title)
                        .body()
                    Spacer()
                }
            }
            HStack {
                textField
                if viewState.includeCancelButton && showCancel {
                    SplytButton(text: Strings.cancel,
                                type: .textOnly,
                                textColor: .lightBlue) {
                        text = ""
                        isFocused = false
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var textField: some View {
        HStack {
            if let iconName = viewState.iconName {
                Image(systemName: iconName)
                    .foregroundColor(Color(splytColor: .gray).opacity(0.5))
                    .padding(.leading, Layout.size(1))
            }
            textEntry
                .frame(height: Layout.size(3))
                .font(.subhead(style: .medium))
                .padding(.vertical, Layout.size(1))
                .padding(.leading, Layout.size(1))
                .focused($isFocused)
            clearButton
        }
        .roundedBackground(cornerRadius: Layout.size(1), fill: Color(splytColor: .gray).opacity(0.10))
        .onTapGesture {
            isFocused.toggle()
        }
    }
    
    @ViewBuilder
    private var textEntry: some View {
        Group {
            switch viewState.entryType {
            case .normal:
                TextField(viewState.placeholder, text: $text)
            case .password:
                ZStack(alignment: .trailing) {
                    SecureField(viewState.placeholder, text: $text)
                        .padding(.trailing, Layout.size(1))
                }
            }
        }
        .textInputAutocapitalization(viewState.autoCapitalize ? nil : .never)
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if !text.isEmpty {
            IconButton(iconName: "xmark.circle",
                       style: .secondary,
                       iconColor: .gray50) {
                text = ""
                // Ensure we refocus
                isFocused = true
            }
                       .padding(.trailing, Layout.size(1))
        }
    }
    
    private var showCancel: Bool {
        return !text.isEmpty || isFocused
    }
}

// MARK: - View State

public struct TextEntryViewState: Equatable {
    let title: String?
    let placeholder: String
    let entryType: TextEntryType
    let iconName: String?
    let includeCancelButton: Bool
    let autoCapitalize: Bool
    
    public init(title: String? = nil,
                placeholder: String = "",
                entryType: TextEntryType = .normal,
                iconName: String? = nil,
                includeCancelButton: Bool = true,
                autoCapitalize: Bool = true) {
        self.title = title
        self.placeholder = placeholder
        self.entryType = entryType
        self.iconName = iconName
        self.includeCancelButton = includeCancelButton
        self.autoCapitalize = autoCapitalize
    }
}

// MARK: - Entry Type

public enum TextEntryType: Equatable {
    case normal
    case password
}

// MARK: - Common View States

public struct TextEntryBuilder {
    public static var searchEntry: TextEntryViewState = .init(placeholder: Strings.search,
                                                              iconName: "magnifyingglass")
}

// MARK: - Strings

fileprivate struct Strings {
    static let search = "Search..."
    static let cancel = "cancel"
}
