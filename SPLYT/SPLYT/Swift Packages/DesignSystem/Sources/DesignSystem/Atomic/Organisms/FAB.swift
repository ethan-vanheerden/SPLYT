
import SwiftUI

public struct FAB: View {
    @Binding private var isPresenting: Bool
    private let viewState: FABViewState
    private let createPlanAction: () -> Void
    private let createWorkoutAction: () -> Void
    
    public init(isPresenting: Binding<Bool>,
                viewState: FABViewState,
                createPlanAction: @escaping () -> Void,
                createWorkoutAction: @escaping () -> Void) {
        self._isPresenting = isPresenting
        self.viewState = viewState
        self.createPlanAction = createPlanAction
        self.createWorkoutAction = createWorkoutAction
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
                    FABIcon(type: isPresenting ? minusIcon : plusIcon) {
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
            .offset(y: isPresenting ? 0 : Layout.size(12.5))
            FABRow(viewState: viewState.createWorkoutState,
                   tapAction: createWorkoutAction)
            .offset(y: isPresenting ? 0 : Layout.size(6.25))
        }
        .isVisible(isPresenting)
        .padding(.trailing, Layout.size(2))
    }
    
    private let plusIcon = FABIconType(size: .primary, imageName: "plus")
    
    private let minusIcon = FABIconType(size: .primary, imageName: "minus")
}

// MARK: - View State

public struct FABViewState: Equatable {
    let createPlanState: FABRowViewState
    let createWorkoutState: FABRowViewState
    
    public init(createPlanState: FABRowViewState,
                createWorkoutState: FABRowViewState) {
        self.createPlanState = createPlanState
        self.createWorkoutState = createWorkoutState
    }
}
