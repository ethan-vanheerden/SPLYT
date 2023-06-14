import SwiftUI
import DesignSystem

struct ActionSliderGallery: View {
    @State private var sliderOneFinished = false
    @State private var sliderTwoFinsihed = false
    private let viewStateOne = ActionSliderViewState(sliderColor: .green,
                                                     backgroundText: "Finish")
    private let viewStateTwo = ActionSliderViewState(sliderColor: .purple,
                                                     backgroundText: "Slide to complete")
    var body: some View {
        VStack {
            Spacer()
            ActionSlider(viewState: viewStateOne,
                         finishSlideAction: { sliderOneFinished = true })
            Text("Is Finished: \(sliderOneFinished.description)")
            ActionSlider(viewState: viewStateTwo,
                         finishSlideAction: { sliderTwoFinsihed = true })
            Text("Is Finished: \(sliderTwoFinsihed.description)")
            Spacer()
        }
        .padding(.horizontal, Layout.size(2))
    }
}
