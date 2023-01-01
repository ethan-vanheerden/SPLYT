
import XCTest
import DesignSystem
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
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
    
    func testBottomSheetResizable() {
        let view = VStack {
            Text("Hello World")
        }
            .bottomSheet(isPresented: .constant(true), detents: [.medium, .large]) {
                Text("Sheet")
            }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
}
