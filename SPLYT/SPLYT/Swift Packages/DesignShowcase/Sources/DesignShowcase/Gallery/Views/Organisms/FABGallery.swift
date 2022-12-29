
import SwiftUI
import DesignSystem

struct FABGallery: View {
    private let viewState = FABViewState(createPlanState: FABRowViewState(title: "CREATE NEW PLAN",
                                                                         imageName: "calendar"),
                                         createWorkoutState: FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                            imageName: "figure.strengthtraining.traditional"))
    var body: some View {
        ZStack {
            Text("Hello, World!")
                .megaText()
            FAB(viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { })
        }
    }
}

