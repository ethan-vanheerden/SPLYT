import SwiftUI
import DesignSystem

struct HomeFABGallery: View {
    @State private var isPresenting = false
    private let viewState = HomeFABViewState(createPlanState: HomeFABRowViewState(title: "CREATE NEW PLAN",
                                                                                  imageName: "calendar"),
                                             createWorkoutState: HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                                                                     imageName: "figure.strengthtraining.traditional"))
    var body: some View {
        ZStack {
            Text("Hello, World!")
                .largeTitle()
            HomeFAB(isPresenting: $isPresenting,
                    viewState: viewState,
                    createPlanAction: { },
                    createWorkoutAction: { })
        }
    }
}

