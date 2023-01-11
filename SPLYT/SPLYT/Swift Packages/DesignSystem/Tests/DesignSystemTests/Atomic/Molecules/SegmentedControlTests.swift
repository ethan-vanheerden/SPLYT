import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

// TODO: run when Xcode fixes UIScene bug
final class SegmentedControlTests: XCTestCase {
    func testSegmentedControl() {
        let view = VStack {
            SegmentedControl(selectedIndex: .constant(0), titles: ["GROUP 1", "GROUP 2", "GROUP 3"])
            SegmentedControl(selectedIndex: .constant(3), titles: ["GROUP 1", "GROUP 2", "GROUP 3", "GROUP 4", "GROUP 5"])
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
}
