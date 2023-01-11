import XCTest
import SnapshotTesting
import DesignSystem
import SwiftUI

// TODO: run when Xcode is not broken
final class NavigationBarTests: XCTestCase {
    let state = NavigationBarViewState(title: "Title")
    let stateLeft = NavigationBarViewState(title: "Title", position: .left)
    
    func testNavigationBarBackButton() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(state: state) { }
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
    
    func testNavigationBarNoBackButton() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(state: state)
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
    
    func testNavigationBarLeft() {
        let view = VStack(alignment: .leading) {
            Text("Hello, World!")
                .padding(.horizontal)
                .navigationBar(state: stateLeft) { }
        }
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
