import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

final class CounterTests: XCTestCase {
    private let viewStateOne = CounterViewState(maxNumber: 60,
                                                label: "min",
                                                backGroundColor: .lightBlue,
                                                textColor: .black)
    private let viewStateTwo = CounterViewState(maxNumber: 10,
                                                minNumber: -10,
                                                label: "sec",
                                                backGroundColor: .purple,
                                                textColor: .white)
    
    func testRepCounter() {
        let view = VStack {
            Spacer()
            Counter(selectedNumber: .constant(8),
                    viewState: viewStateOne)
            Counter(selectedNumber: .constant(-10),
                    viewState: viewStateTwo)
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
