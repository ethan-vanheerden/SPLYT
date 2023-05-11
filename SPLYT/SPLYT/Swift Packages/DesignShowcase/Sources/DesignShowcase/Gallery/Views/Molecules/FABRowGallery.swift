
import SwiftUI
import DesignSystem

struct HomeFABRowGallery: View {
    let viewStateOne = HomeFABRowViewState(title: "CREATE NEW PLAN",
                                           imageName: "calendar")
    let viewStateTwo = HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                           imageName: "figure.strengthtraining.traditional")
    
    var body: some View {
        VStack(alignment: .trailing) {
            HomeFABRow(viewState: viewStateOne, tapAction: { })
            HomeFABRow(viewState: viewStateTwo, tapAction: { })
        }
    }
}
