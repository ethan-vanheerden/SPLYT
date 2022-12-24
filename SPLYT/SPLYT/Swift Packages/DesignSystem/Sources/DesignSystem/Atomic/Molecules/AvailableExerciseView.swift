import SwiftUI

struct AvailableExerciseView: View {
    private let viewState: AvailableExerciseViewState
    @State private var isSelected: Bool = false
    
    public init(viewState: AvailableExerciseViewState) {
        self.viewState = viewState
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


// MARK: - ViewState

public struct AvailableExerciseViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let name: String
    
    public init(id: AnyHashable = UUID(),
                name: String) {
        self.id = id
        self.name = name
    }
}
