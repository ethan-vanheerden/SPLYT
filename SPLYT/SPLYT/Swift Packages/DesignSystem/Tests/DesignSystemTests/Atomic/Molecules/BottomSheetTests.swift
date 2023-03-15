
import XCTest
@testable import DesignSystem
import SnapshotTesting
import SwiftUI

final class BottomSheetTests: XCTestCase {
    func testBottomSheetNotResizable() {
        let view = VStack {
            Text("Hello World")
        }
            .bottomSheet(isPresented: .constant(true), currentSize: .constant(.medium)) {
                Text("Sheet")
            }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testBottomSheetResizable() {
        let view = VStack {
            Text("Hello World")
        }
            .bottomSheet(isPresented: .constant(true), currentSize: .constant(.percent(0.1)), detents: [.percent(0.1)]) {
                Text("Sheet")
            }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX))
    }
    
    func testBottomSheetSizeOffset() {
        let height: CGFloat = 1
        XCTAssertEqual(BottomSheetSize.small.offset(containerHeight: height), 0.8)
        XCTAssertEqual(BottomSheetSize.medium.offset(containerHeight: height), 0.5)
        XCTAssertEqual(BottomSheetSize.large.offset(containerHeight: height), 0.01)
        XCTAssertEqual(BottomSheetSize.percent(0.7).offset(containerHeight: height), 0.3, accuracy: 0.00001)
    }
}
