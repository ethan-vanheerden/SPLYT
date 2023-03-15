
import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TabBarTests: XCTestCase {
    func testTabBar() throws {
        let view = VStack {
            TabBar(selectedTab: .constant(.home))
            TabBar(selectedTab: .constant(.history))
            TabBar(selectedTab: .constant(.settings))
        }
        .padding(.horizontal)
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
}
