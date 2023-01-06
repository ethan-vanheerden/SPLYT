
import XCTest
@testable import DesignSystem
import SnapshotTesting
import SwiftUI

// TODO: run when Xcode fixes UIScene bug
final class BottomSheetTests: XCTestCase {
    func testBottomSheetNotResizable() {
        let view = VStack {
            Text("Hello World")
        }
            .bottomSheet(isPresented: .constant(true)) {
                Text("Sheet")
            }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: true)
    }
    
    func testBottomSheetResizable() {
        let view = VStack {
            Text("Hello World")
        }
            .bottomSheet(isPresented: .constant(true), detents: [.percent(0.1)]) {
                Text("Sheet")
            }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .iPhoneX), record: true)
    }
    
    func testBottomSheetSizeOffset() {
        let height: CGFloat = 1
        XCTAssertEqual(BottomSheetSize.small.offset(containerHeight: height), 0.8)
        XCTAssertEqual(BottomSheetSize.medium.offset(containerHeight: height), 0.5)
        XCTAssertEqual(BottomSheetSize.large.offset(containerHeight: height), 0.01)
        XCTAssertEqual(BottomSheetSize.percent(0.7).offset(containerHeight: height), 0.3)
    }
}