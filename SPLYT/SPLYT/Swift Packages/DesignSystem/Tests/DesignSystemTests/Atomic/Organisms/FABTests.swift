import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    let fabItems: [FABRowViewState] = [
        FABRowViewState(title: "CREATE NEW PLAN",
                        imageName: "calendar",
                        tapAction: { }),
        FABRowViewState(title: "CREATE NEW WORKOUT",
                        imageName: "figure.strengthtraining.traditional",
                        tapAction: { })
    ]
    
    func testFABNotExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .bodyText()
            FAB(items: fabItems)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
    
    func testFABExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .bodyText()
            FAB(items: fabItems,
                isPresentingOverride: true)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
}
