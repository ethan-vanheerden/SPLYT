import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class IconImageTests: XCTestCase {
    func testIconImage() throws {
        let view = VStack {
            Spacer()
            IconImage(imageName: "theatermask.and.paintbrush.fill",
                      backgroundColor: .darkBlue)
            IconImage(imageName: "stopwatch.fill",
                      backgroundColor: .blue)
            IconImage(imageName: "pencil",
                      imageColor: .red,
                      backgroundColor: .yellow)
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
