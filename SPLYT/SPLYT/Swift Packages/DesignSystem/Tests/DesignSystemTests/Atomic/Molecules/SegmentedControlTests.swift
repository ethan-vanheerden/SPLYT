
import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

// TODO: run when XCode fixes UIScene bug
final class SegmentedControlTests: XCTestCase {
    func testSegmentedControl() {
        let view = VStack {
            SegmentedControl(selectedIndex: $selectionOne, titles: itemsOne)
            SegmentedControl(selectedIndex: $selectionTwo, titles: itemsTwo)
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
