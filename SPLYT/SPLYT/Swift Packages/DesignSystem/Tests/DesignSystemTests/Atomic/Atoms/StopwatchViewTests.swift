import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class StopwatchViewTests: XCTestCase {
    func testStopwatchView() throws {
        let view = VStack {
            Spacer()
            StopwatchView(secondsElapsed: .constant(0))
            StopwatchView(secondsElapsed: .constant(3600))
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
