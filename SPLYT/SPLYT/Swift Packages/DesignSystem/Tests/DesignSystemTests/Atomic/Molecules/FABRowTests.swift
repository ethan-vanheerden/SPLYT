import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABRowTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    let viewStateOne = FABRowViewState(title: "CREATE NEW PLAN",
                                       imageName: "calendar",
                                       tapAction: { print("Create new plan") })
    let viewStateTwo = FABRowViewState(title: "CREATE NEW WORKOUT",
                                       imageName: "figure.strengthtraining.traditional",
                                       tapAction: { print("Create new workout") })
    
    func testFABRow() throws {
        let view = VStack(alignment: .trailing) {
            FABRow(viewState: viewStateOne)
            FABRow(viewState: viewStateTwo)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
