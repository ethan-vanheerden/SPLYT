import XCTest
import DesignSystem
import SnapshotTesting
import SwiftUI

final class ErrorViewTests: XCTestCase {
    func testErrorView() {
        let view = VStack {
            ErrorView()
            ErrorView(retryAction: {},
                      backAction: {})
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
}
