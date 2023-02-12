import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SetEntryTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    func testSetEntry() throws {
        let view = VStack {
            Spacer()
            SetEntry(id: "set-1",
                     title: "lbs",
                     placeholder: "12.5",
                     inputType: .weight) { _, _ in }
            SetEntry(id: "set-2",
                     title: "REPS",
                     placeholder: "0",
                     inputType: .reps) { _, _ in }
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
