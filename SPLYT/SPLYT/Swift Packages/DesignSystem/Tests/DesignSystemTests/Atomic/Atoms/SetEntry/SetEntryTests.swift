import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SetEntryTests: XCTestCase {
    func testSetEntry() throws {
        let view = VStack {
            Spacer()
            SetEntry(input: .constant(""),
                     title: "lbs",
                     keyboardType: .weight)
            SetEntry(input: .constant(""),
                     title: "lbs",
                     keyboardType: .weight,
                     placeholder: "12")
            SetEntry(input: .constant("12"),
                     title: "reps",
                     keyboardType: .reps)
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
