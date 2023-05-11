import SwiftUI

public struct HomeFAB: View {
    @Binding private var isPresenting: Bool
    private let viewState: HomeFABViewState
    private let createPlanAction: () -> Void
    private let createWorkoutAction: () -> Void
    
    public init(isPresenting: Binding<Bool>,
                viewState: HomeFABViewState,
                createPlanAction: @escaping () -> Void,
                createWorkoutAction: @escaping () -> Void) {
        self._isPresenting = isPresenting
        self.viewState = viewState
        self.createPlanAction = createPlanAction
        self.createWorkoutAction = createWorkoutAction
    }
    
    public var body: some View {
        FAB(isPresenting: $isPresenting,
            baseIcon: baseIcon) {
            fabRows
        }
    }
    
    private var baseIcon: FABIconViewState {
        if isPresenting {
            return FABIconViewState(size: .primary(backgroundColor: .lightBlue,
                                                   iconColor: .white),
                                    imageName: "minus")
        } else {
            return FABIconViewState(size: .primary(backgroundColor: .lightBlue,
                                                   iconColor: .white),
                                    imageName: "plus")
        }
    }
    
    private var fabRows: some View {
        VStack(alignment: .trailing) {
            HomeFABRow(viewState: viewState.createPlanState,
                       tapAction: createPlanAction)
            .offset(y: isPresenting ? 0 : Layout.size(12.5))
            HomeFABRow(viewState: viewState.createWorkoutState,
                       tapAction: createWorkoutAction)
            .offset(y: isPresenting ? 0 : Layout.size(6.25))
        }
        .isVisible(isPresenting)
        .padding(.trailing, Layout.size(2))
    }
}

// MARK: - View State

public struct HomeFABViewState: Equatable {
    let createPlanState: HomeFABRowViewState
    let createWorkoutState: HomeFABRowViewState
    
    public init(createPlanState: HomeFABRowViewState,
                createWorkoutState: HomeFABRowViewState) {
        self.createPlanState = createPlanState
        self.createWorkoutState = createWorkoutState
    }
}
