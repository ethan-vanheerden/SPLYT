import SwiftUI
import ExerciseCore

public struct SetModifiersView: View {
    @EnvironmentObject private var userTheme: UserTheme
    private let selectModifierAction: (SetModifierViewState) -> Void
    
    public init(selectModifierAction: @escaping (SetModifierViewState) -> Void) {
        self.selectModifierAction = selectModifierAction
    }
    
    public var body: some View {
        HStack(spacing: Layout.size(2.5)) {
            Spacer()
            ForEach(SetModifierViewState.allCases, id: \.title) { modifierState in
                Tag(viewState: TagFactory.tagFromModifier(modifier: modifierState,
                                                          color: userTheme.theme))
                .onTapGesture {
                    selectModifierAction(modifierState)
                }
            }
            Spacer()
        }
    }
}
