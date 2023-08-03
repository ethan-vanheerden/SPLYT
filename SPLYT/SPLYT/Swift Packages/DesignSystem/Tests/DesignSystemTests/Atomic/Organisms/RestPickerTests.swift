import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class RestPickerTests: XCTestCase {
    func testRestPicker() throws {
        let view = VStack {
            Spacer()
            RestPicker(minutes: .constant(2),
                       seconds: .constant(30),
                       confirmAction: { },
                       cancelAction: { })
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
}
