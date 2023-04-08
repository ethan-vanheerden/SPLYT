import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SetEntryTests: XCTestCase {
    func testSetEntry() throws {
        let view = VStack {
            Spacer()
            SetEntry(title: "lbs",
                     input: .weight(12.5)) { _ in }
            SetEntry(title: "reps",
                     input: .reps(nil)) { _ in }
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
