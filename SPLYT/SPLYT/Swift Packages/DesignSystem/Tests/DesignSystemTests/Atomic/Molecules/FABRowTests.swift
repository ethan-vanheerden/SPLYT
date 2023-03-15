import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABRowTests: XCTestCase {
    let viewStateOne = FABRowViewState(title: "CREATE NEW PLAN",
                                       imageName: "calendar")
    let viewStateTwo = FABRowViewState(title: "CREATE NEW WORKOUT",
                                       imageName: "figure.strengthtraining.traditional")
    
    func testFABRow() throws {
        let view = VStack(alignment: .trailing) {
            FABRow(viewState: viewStateOne,
                   tapAction: { print("Create new plan") })
            FABRow(viewState: viewStateTwo,
                   tapAction: { print("Create new workout") })
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
