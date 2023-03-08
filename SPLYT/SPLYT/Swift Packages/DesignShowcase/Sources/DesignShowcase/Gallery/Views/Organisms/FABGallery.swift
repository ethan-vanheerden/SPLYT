
import SwiftUI
import DesignSystem

struct FABGallery: View {
    @State private var isPresenting = false
    private let viewState = FABViewState(createPlanState: FABRowViewState(title: "CREATE NEW PLAN",
                                                                         imageName: "calendar"),
                                         createWorkoutState: FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                            imageName: "figure.strengthtraining.traditional"))
    var body: some View {
        ZStack {
            Text("Hello, World!")
                .largeTitle()
            FAB(isPresenting: $isPresenting,
                viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { })
        }
    }
}

