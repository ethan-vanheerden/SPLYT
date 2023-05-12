import XCTest
@testable import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class RestFABTests: XCTestCase {
    func testRestFABNotExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            RestFAB(isPresenting: .constant(false),
                    viewState: RestFABViewState(restPresets: [30, 60, 90]),
                    selectRestAction: { _ in },
                    selectMoreAction: { },
                    stopAction: { })
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    func testRestFABExpanded() throws {
        let view = ZStack {
            Text("Hello, World!")
                .body()
            RestFAB(isPresenting: .constant(true),
                    viewState: RestFABViewState(restPresets: [30, 60, 90]),
                    selectRestAction: { _ in },
                    selectMoreAction: { },
                    stopAction: { })
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
}
