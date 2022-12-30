import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TileTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    func testTile() throws {
        let view = VStack {
            Tile {
                Text("Hello World!")
            }
            
            Tile {
                Circle()
                    .fill(Color.red)
                    .frame(width: Layout.size(1))
            }
        }.padding()
        
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
