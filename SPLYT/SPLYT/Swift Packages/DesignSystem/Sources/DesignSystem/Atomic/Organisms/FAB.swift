
import SwiftUI

public struct FAB: View {
    @State private var isPresenting = false
    private let viewState: FABViewState
    private let createPlanAction: () -> Void
    private let createWorkoutAction: () -> Void
    
    public init(viewState: FABViewState,
                createPlanAction: @escaping () -> Void,
                createWorkoutAction: @escaping () -> Void) {
        self.viewState = viewState
        self.createPlanAction = createPlanAction
        self.createWorkoutAction = createWorkoutAction
    }
    
    /// Initializer for testing purposes
    init(viewState: FABViewState,
         createPlanAction: @escaping () -> Void,
         createWorkoutAction: @escaping () -> Void,
         isPresentingOverride: Bool) {
        self.viewState = viewState
        self.createPlanAction = createPlanAction
        self.createWorkoutAction = createWorkoutAction
        self._isPresenting = State(initialValue: isPresentingOverride)
    }
    
    public var body: some View {
        ZStack {
            Scrim()
                .edgesIgnoringSafeArea(.all)
                .isVisible(isPresenting)
                .onTapGesture {
                    withAnimation(Animation.easeOut) {
                        isPresenting.toggle()
                    }
                }
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                    fabItems
                    FABIcon(type: plusIcon) {
                        // Adds a small vibration effect
                        let haptic = UIImpactFeedbackGenerator(style: .rigid)
                        haptic.impactOccurred()
                        withAnimation(Animation.easeOut) {
                            isPresenting.toggle()
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var fabItems: some View {
        VStack(alignment: .trailing) {
            FABRow(viewState: viewState.createPlanState,
                   tapAction: createPlanAction)
            FABRow(viewState: viewState.createWorkoutState,
                   tapAction: createWorkoutAction)
        }
        .isVisible(isPresenting)
        .padding(.trailing, Layout.size(2))
    }
    
    private var plusIcon: FABIconType {
        return FABIconType(size: .primary, imageName: "plus")
    }
}

// MARK: - ViewState

public struct FABViewState: ItemViewState, Equatable {
    public let id: AnyHashable
    let createPlanState: FABRowViewState
    let createWorkoutState: FABRowViewState
    
    public init(id: AnyHashable = UUID(),
                createPlanState: FABRowViewState,
                createWorkoutState: FABRowViewState) {
        self.id = id
        self.createPlanState = createPlanState
        self.createWorkoutState = createWorkoutState
    }
}


struct FAB_Previews: PreviewProvider {
    static var previews: some View {
        FAB(viewState: FABViewState(createPlanState: FABRowViewState(title: "CREATE NEW PLAN",
                                                                     imageName: "calendar"),
                                    createWorkoutState: FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                        imageName: "figure.strengthtraining.traditional")),
            createPlanAction: { },
            createWorkoutAction: { })
    }
}
