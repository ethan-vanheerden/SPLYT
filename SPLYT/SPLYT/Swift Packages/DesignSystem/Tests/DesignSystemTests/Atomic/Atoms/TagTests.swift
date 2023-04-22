import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TagTests: XCTestCase {
    func testTag() throws {
        let view = VStack(spacing: Layout.size(1)) {
            Spacer()
            Tag(viewState: TagViewState(title: "Drop Set", color: .green))
            Tag(viewState: TagViewState(title: "Rest/Pause", color: .gray))
            Tag(viewState: TagViewState(title: "Eccentric", color: .red))
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
