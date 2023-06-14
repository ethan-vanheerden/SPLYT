import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class CollapseHeaderTests: XCTestCase {
    func testCollapseHeader() throws {
        let view = VStack {
            CollapseHeader(isExpanded: .constant(false),
                           viewState: CollapseHeaderViewState(title: "Title")) {
                Text("Hello, world!")
            }
            CollapseHeader(isExpanded: .constant(true),
                           viewState: CollapseHeaderViewState(title: "Another title",
                                                              color: .lightBlue,
                                                              isComplete: true)) {
                Text("Hello, world!")
            }
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
