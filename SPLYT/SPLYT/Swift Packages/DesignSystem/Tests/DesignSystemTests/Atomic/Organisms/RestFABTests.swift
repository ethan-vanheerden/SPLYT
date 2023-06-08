import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class RestFABTests: XCTestCase {
    private let restPresets = [60, 90, 120]
    
    func testRestFABNotRestingNotExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            RestFAB(isPresenting:.constant(false),
                    workoutSeconds: .constant(0),
                    viewState: viewState(isResting: false),
                    selectRestAction: { },
                    stopRestAction: { })
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    func testRestFABNotRestingExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            RestFAB(isPresenting:.constant(true),
                    workoutSeconds: .constant(0),
                    viewState: viewState(isResting: false),
                    selectRestAction: { },
                    stopRestAction: { })
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    func testRestFABResting() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            RestFAB(isPresenting:.constant(false),
                    workoutSeconds: .constant(0),
                    viewState: viewState(isResting: true),
                    selectRestAction: { },
                    stopRestAction: { })
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    private func viewState(isResting: Bool) -> RestFABViewState {
        return RestFABViewState(isResting: isResting,
                                restPresets: restPresets)
    }
}
