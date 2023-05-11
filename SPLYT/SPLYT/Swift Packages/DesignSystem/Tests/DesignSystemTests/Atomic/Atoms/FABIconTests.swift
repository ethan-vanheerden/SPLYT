import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABIconTests: XCTestCase {
    func testFABIcon() throws {
        let view = VStack(spacing: Layout.size(6)) {
            FABIcon(viewState: FABIconViewState(size: .primary, imageName: "plus"), tapAction: { })
            FABIcon(viewState: FABIconViewState(size: .secondary, imageName: "calendar"), tapAction: { })
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
