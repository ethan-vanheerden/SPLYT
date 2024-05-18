import SwiftUI
import DesignSystem

struct ProgressBarGallery: View {
    private let viewStateOne = ProgressBarViewState(fractionCompleted: 0)
    private let viewStateTwo = ProgressBarViewState(fractionCompleted: 0.33,
                                            color: .lightBlue)
    private let viewStateThree = ProgressBarViewState(fractionCompleted: 0.55,
                                              color: .green)
    private let viewStateFour = ProgressBarViewState(fractionCompleted: 1.0,
                                             color: .yellow)
    
    var body: some View {
        VStack {
            ProgressBar(viewState: viewStateOne)
            ProgressBar(viewState: viewStateTwo)
            ProgressBar(viewState: viewStateThree)
            ProgressBar(viewState: viewStateFour)
        }
        .padding(.horizontal, Layout.size(2))
    }
}
