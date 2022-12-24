import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class ScrimTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    func testScrim() throws {
        let view = ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color.red)
                Text("MORE TEXT")
                    .megaText()
                Rectangle()
                    .fill(Color.blue)
            }
            Scrim()
                .edgesIgnoringSafeArea(.all)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
