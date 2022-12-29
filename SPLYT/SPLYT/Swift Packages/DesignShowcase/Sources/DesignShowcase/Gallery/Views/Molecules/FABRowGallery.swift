
import SwiftUI
import DesignSystem

struct FABRowGallery: View {
    let viewStateOne = FABRowViewState(title: "CREATE NEW PLAN",
                                       imageName: "calendar")
    let viewStateTwo = FABRowViewState(title: "CREATE NEW WORKOUT",
                                       imageName: "figure.strengthtraining.traditional")
    
    var body: some View {
        VStack(alignment: .trailing) {
            FABRow(viewState: viewStateOne, tapAction: { })
            FABRow(viewState: viewStateTwo, tapAction: { })
        }
    }
}
