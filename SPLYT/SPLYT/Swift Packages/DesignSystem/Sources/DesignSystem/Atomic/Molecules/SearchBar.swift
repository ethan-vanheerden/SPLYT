import SwiftUI

public struct SearchBar: View {
    @FocusState private var fieldFocused: Bool
    @Binding private var searchText: String
    
    public init(searchText: Binding<String>) {
        self._searchText = searchText
    }
    
    public var body: some View {
        EmptyView()
    }
}
