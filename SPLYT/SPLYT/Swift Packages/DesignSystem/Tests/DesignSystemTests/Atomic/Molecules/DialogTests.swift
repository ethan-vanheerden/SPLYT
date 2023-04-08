import XCTest
import SnapshotTesting
import DesignSystem
import SwiftUI

final class DialogTests: XCTestCase {
    func testMenuItem() {
        let viewState = MenuItemViewState(title: "TITLE")
        let subtitleViewState = MenuItemViewState(title: "TITLE",
                                                  subtitle: "THIS IS A SUBTITLE")
        let view = VStack {
            MenuItem(viewState: viewState) { _ in }
            MenuItem(viewState: subtitleViewState) { _ in }
            Spacer()
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
    
    func testDialog_JustTitle() {
        let viewState = DialogViewState(title: "Dialog title",
                                        primaryButtonTitle: "Ok")
        
        let view = VStack {
            Text("Hello, world!")
        }.dialog(isOpen: true, viewState: viewState, primaryAction: { })
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testDialog_Complex() {
        let viewState = DialogViewState(title: "Dialog title",
                                        subtitle: "All of this text is the dialog subtitle. It can be very long.",
                                        primaryButtonTitle: "Ok",
                                        secondaryButtonTitle: "Cancel")
        
        let view = VStack {
            Text("Hello, world!")
        }.dialog(isOpen: true, viewState: viewState, primaryAction: { })
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .mediumImage()))
    }
}
