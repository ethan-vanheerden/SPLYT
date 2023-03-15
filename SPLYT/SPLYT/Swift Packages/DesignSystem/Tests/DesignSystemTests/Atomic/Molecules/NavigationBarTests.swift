import XCTest
import SnapshotTesting
import DesignSystem
import SwiftUI

final class NavigationBarTests: XCTestCase {
    let state = NavigationBarViewState(title: "Title")
    let stateLeft = NavigationBarViewState(title: "Title", position: .left)
    
    func testNavigationBarBackButton() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(viewState: state) { }
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testNavigationBarNoBackButton() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(viewState: state)
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testNavigationBarLeft() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(viewState: stateLeft) { }
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
