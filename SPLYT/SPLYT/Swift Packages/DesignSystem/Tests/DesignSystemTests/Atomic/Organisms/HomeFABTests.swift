import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class HomeFABTests: XCTestCase {
    private let viewState = HomeFABViewState(createPlanState: HomeFABRowViewState(title: "CREATE NEW PLAN",
                                                                                  imageName: "calendar"),
                                             createWorkoutState: HomeFABRowViewState(title: "CREATE NEW WORKOUT",
                                                                                     imageName: "figure.strengthtraining.traditional"))
    
    func testHomeFABNotExpanded() throws {
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
    
    func testHomeFABExpanded() throws {
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
