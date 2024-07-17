import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class ScrimTests: XCTestCase {
    func testScrim() throws {
        let view = ZStack {
            VStack {
                Text("Hello, World!")
                Rectangle()
                    .fill(Color(SplytColor.red))
                Text("MORE TEXT")
                    .largeTitle()
                Rectangle()
                    .fill(Color(SplytColor.lightBlue))
            }
            Scrim()
                .edgesIgnoringSafeArea(.all)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
