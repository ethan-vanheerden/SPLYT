import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SectionHeaderTests: XCTestCase {
    func testSectionHeader() throws {
        let view = VStack {
            SectionHeader(viewState: SectionHeaderViewState(title: "TITLE"))
            SectionHeader(viewState: SectionHeaderViewState(title: "LONGER TITLE VERY LONG"))
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
