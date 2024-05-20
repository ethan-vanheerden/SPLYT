import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

final class ActionSliderTests: XCTestCase {
    private let viewStateOne = ActionSliderViewState(sliderColor: .green,
                                                     backgroundText: "Finish")
    private let viewStateTwo = ActionSliderViewState(sliderColor: .darkBlue,
                                                     backgroundText: "Slide to complete")
    func testActionSlider() {
        let view = VStack {
            Spacer()
            ActionSlider(viewState: viewStateOne,
                         finishSlideAction: { })
            ActionSlider(viewState: viewStateTwo,
                         finishSlideAction: { })
            Spacer()
        }
        .padding(.horizontal, Layout.size(1))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
