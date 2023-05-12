import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABIconTests: XCTestCase {
    func testFABIcon() throws {
        let view = VStack(spacing: Layout.size(6)) {
            FABIcon(viewState: FABIconViewState(size: .primary(backgroundColor: .lightBlue,
                                                               iconColor: .white),
                                                imageName: "plus"),
                    tapAction: { })
            FABIcon(viewState: FABIconViewState(size: .primary(backgroundColor: .white,
                                                               iconColor: .lightBlue),
                                                imageName: "timer"),
                    tapAction: { })
            FABIcon(viewState: FABIconViewState(size: .secondary(backgroundColor: .white,
                                                                 iconColor: .lightBlue),
                                                imageName: "calendar"),
                    tapAction: { })
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
