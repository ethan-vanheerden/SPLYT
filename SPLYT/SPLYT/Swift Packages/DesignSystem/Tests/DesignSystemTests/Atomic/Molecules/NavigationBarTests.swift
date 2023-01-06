
import XCTest
import SnapshotTesting
import DesignSystem
import SwiftUI

// TODO: run when Xcode is not broken
final class NavigationBarTests: XCTestCase {
    func testNavigationBar() {
        let viewStateOne = NavigationBarViewState(title: "Title")
        let viewStateTwo = NavigationBarViewState(title: "Another Title")
        
        let view = VStack(alignment: .leading) {
            NavigationBar(viewState: viewStateOne)
            NavigationBar(viewState: viewStateTwo, dismissAction: { print("Hello, world!")})
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
