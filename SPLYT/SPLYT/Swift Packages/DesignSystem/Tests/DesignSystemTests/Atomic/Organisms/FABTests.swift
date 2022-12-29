import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    private let viewState = FABViewState(createPlanState: FABRowViewState(title: "CREATE NEW PLAN",
                                                                         imageName: "calendar"),
                                         createWorkoutState: FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                            imageName: "figure.strengthtraining.traditional"))
    
    func testFABNotExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .bodyText()
            FAB(viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { })
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
    
    func testFABExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .bodyText()
            FAB(viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { },
                isPresentingOverride: true)
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()), record: true)
    }
}
