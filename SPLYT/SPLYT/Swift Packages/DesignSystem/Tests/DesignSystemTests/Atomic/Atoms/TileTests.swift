import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TileTests: XCTestCase {
    func testTile() throws {
        let view = VStack {
            Tile {
                Text("Hello World!")
            }
            
            Tile {
                Circle()
                    .fill(Color(splytColor: .red))
                    .frame(width: Layout.size(1))
            }
        }.padding(Layout.size(2))
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
