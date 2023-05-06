import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class ProgressBarTests: XCTestCase {
    private let viewStateOne = ProgressBarViewState(fractionCompleted: 0,
                                            color: .lightBlue,
                                            outlineColor: .lightBlue)
    private let viewStateTwo = ProgressBarViewState(fractionCompleted: 0.33,
                                            color: .lightBlue,
                                            outlineColor: .lightBlue)
    private let viewStateThree = ProgressBarViewState(fractionCompleted: 0.55,
                                              color: .green)
    private let viewStateFour = ProgressBarViewState(fractionCompleted: 1.0,
                                             color: .yellow,
                                             outlineColor: .gray)
    
    func testProgressBar() throws {
        let view = VStack {
            ProgressBar(viewState: viewStateOne)
            ProgressBar(viewState: viewStateTwo)
            ProgressBar(viewState: viewStateThree)
            ProgressBar(viewState: viewStateFour)
        }
        .padding(.horizontal, Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
