import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABIconTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    func testFABIcon() throws {
        let view = VStack(spacing: Layout.size(6)) {
            FABIcon(type: FABIconType(size: .primary, imageName: "plus"))
            FABIcon(type: FABIconType(size: .secondary, imageName: "calendar"))
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
