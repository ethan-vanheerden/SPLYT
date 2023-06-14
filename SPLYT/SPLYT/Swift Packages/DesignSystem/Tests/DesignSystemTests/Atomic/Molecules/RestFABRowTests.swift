import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class RestFABRowTests: XCTestCase {
    func testRestFABRow() throws {
        let view = VStack {
            Spacer()
            RestFABRow(seconds: 30, tapAction: { })
            RestFABRow(seconds: 60, tapAction: { })
            RestFABRow(seconds: 150, tapAction: { })
            Spacer()
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
