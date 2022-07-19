import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

class SectionHeaderTests: XCTestCase {
    func testSectionHeader() throws {
        let view = VStack {
            SectionHeader(viewState: SectionHeaderViewState(text: "TITLE"))
            SectionHeader(viewState: SectionHeaderViewState(text: "LONGER TITLE VERY LONG"))
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(size: CGSize(width: 250, height: 200)))
    }
}
