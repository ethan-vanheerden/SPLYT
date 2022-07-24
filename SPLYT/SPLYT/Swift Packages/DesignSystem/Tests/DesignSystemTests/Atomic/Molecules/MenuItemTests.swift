import XCTest
import SnapshotTesting
import DesignSystem
import SwiftUI

final class MenuItemTests: XCTestCase {
    func testMenuItem() {
        let viewState = MenuItemViewState(title: "TITLE")
        let subtitleViewState = MenuItemViewState(title: "TITLE",
                                                          subtitle: "THIS IS A SUBTITLE")
        let view = VStack {
            MenuItem(viewState: viewState) { viewState in
                print(viewState)
            }
            MenuItem(viewState: subtitleViewState) { viewState in
                print(viewState)
            }
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
