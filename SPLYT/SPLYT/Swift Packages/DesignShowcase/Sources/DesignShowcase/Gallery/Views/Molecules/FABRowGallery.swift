
import SwiftUI
import DesignSystem

struct FABRowGallery: View {
    let viewStateOne = FABRowViewState(title: "CREATE NEW PLAN",
                                       imageName: "calendar",
                                       tapAction: { print("Create new plan") })
    let viewStateTwo = FABRowViewState(title: "CREATE NEW WORKOUT",
                                       imageName: "figure.strengthtraining.traditional",
                                       tapAction: { print("Create new workout") })
    
    var body: some View {
        VStack(alignment: .trailing) {
            FABRow(viewState: viewStateOne)
            FABRow(viewState: viewStateTwo)
        }
    }
}
