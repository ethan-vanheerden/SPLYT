import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

final class RepCounterTests: XCTestCase {
    func testRepCounter() {
        let view = VStack {
            RepCounter(selectedNumber: .constant(8))
            RepCounter(selectedNumber: .constant(100))
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
