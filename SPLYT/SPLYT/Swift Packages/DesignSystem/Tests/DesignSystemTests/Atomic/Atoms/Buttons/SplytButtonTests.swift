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
                            color: .red,
                            textColor: .black,
                            isEnabled: true) { }
                SplytButton(text: "Confirm",
                            color: .green,
                            isEnabled: true) { }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        size: .secondary,
                        isEnabled: true) { }
            SplytButton(text: "Button no animations",
                        size: .primary,
                        color: .white,
                        textColor: .black,
                        outlineColor: .black,
                        isEnabled: true,
                        animationEnabled: false) { }
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
                            color: .red,
                            textColor: .black,
                            isEnabled: false) { }
                SplytButton(text: "Confirm",
                            color: .green,
                            isEnabled: false) { }
                Spacer()
            }
            SplytButton(text: "Secondary Button",
                        size: .secondary,
                        isEnabled: false) { }
            SplytButton(text: "Button no animations",
                        size: .primary,
                        color: .white,
                        textColor: .black,
                        outlineColor: .black,
                        isEnabled: false,
                        animationEnabled: false) { }
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
