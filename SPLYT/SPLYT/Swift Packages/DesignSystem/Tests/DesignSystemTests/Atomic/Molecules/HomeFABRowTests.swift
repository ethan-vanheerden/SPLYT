import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class HomeFABRowTests: XCTestCase {
    let viewStateOne = HomeFABRowViewState(title: "CREATE NEW PLAN",
                                           imageName: "calendar")
    let viewStateTwo = HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                           imageName: "figure.strengthtraining.traditional")
    
    func testHomeFABRow() throws {
        let view = VStack(alignment: .trailing) {
            HomeFABRow(viewState: viewStateOne,
                       tapAction: { print("Create new plan") })
            HomeFABRow(viewState: viewStateTwo,
                       tapAction: { print("Create new workout") })
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
