import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SplytButtonTests: XCTestCase {
    func testButtonsEnabled() throws {
        let view = VStack {
            SplytButton(text: "BUTTON TEXT",
                        isEnabled: true) { }
            HStack(spacing: Layout.size(2)) {
                Spacer()
                SplytButton(text: "cancel",
                            type: .primary(color: .red),
                            textColor: .black,
                            isEnabled: true) { }
                SplytButton(text: "Confirm",
                            type: .primary(color: .green),
                            isEnabled: true) { }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        type: .secondary(),
                        isEnabled: true) { }
            SplytButton(text: "Button no animations",
                        type: .primary(color: .white),
                        textColor: .black,
                        isEnabled: true,
                        animationEnabled: false) { }
            SplytButton(text: "Text Only",
                        type: .textOnly,
                        textColor: .lightBlue,
                        isEnabled: true) { }
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testButtonsDisabled() throws {
        let view = VStack {
            SplytButton(text: "BUTTON TEXT",
                        isEnabled: false) { }
            HStack(spacing: Layout.size(2)) {
                Spacer()
                SplytButton(text: "cancel",
                            type: .primary(color: .red),
                            textColor: .black,
                            isEnabled: false) { }
                SplytButton(text: "Confirm",
                            type: .primary(color: .green),
                            isEnabled: false) { }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        type: .secondary(),
                        isEnabled: false) { }
            SplytButton(text: "Button no animations",
                        type: .primary(color: .white),
                        textColor: .black,
                        isEnabled: false,
                        animationEnabled: false) { }
            SplytButton(text: "Text Only",
                        type: .textOnly,
                        textColor: .lightBlue,
                        isEnabled: false) { }
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
