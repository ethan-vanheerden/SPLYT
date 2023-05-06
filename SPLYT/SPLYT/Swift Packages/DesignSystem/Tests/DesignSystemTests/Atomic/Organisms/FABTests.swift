import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class FABTests: XCTestCase {
    private let viewState = HomeFABViewState(createPlanState: FABRowViewState(title: "CREATE NEW PLAN",
                                                                         imageName: "calendar"),
                                         createWorkoutState: FABRowViewState(title: "CREATE NEW WORKOUT",
                                                                            imageName: "figure.strengthtraining.traditional"))
    
    func testFABNotExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            HomeFAB(isPresenting: .constant(false),
                viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { })
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    func testFABExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            HomeFAB(isPresenting: .constant(true),
                viewState: viewState,
                createPlanAction: { },
                createWorkoutAction: { })
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
}
