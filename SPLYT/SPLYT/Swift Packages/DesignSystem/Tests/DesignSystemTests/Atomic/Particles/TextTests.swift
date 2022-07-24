import XCTest
import SnapshotTesting
import SwiftUI
import DesignSystem

final class TextTests: XCTestCase {
    func testText() {
        let view = VStack(spacing: Layout.size(1)) {
            Text("MEGA Text")
                .megaText()
            Text("TITLE Text")
                .titleText()
            Text("SUBTITLE Text")
                .subtitleText()
            Text("DESCRIPTION Text")
                .descriptionText()
            Text("BODY Text")
                .bodyText()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
