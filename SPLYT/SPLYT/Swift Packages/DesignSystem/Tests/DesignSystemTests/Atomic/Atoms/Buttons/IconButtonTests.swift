import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class IconButtonTests: XCTestCase {
    func testButtonsEnabled() throws {
        let view = VStack {
            IconButton(iconName: "plus",
                       isEnabled: true) { }
            IconButton(iconName: "minus",
                       style: .primary(backgroundColor: .red),
                       iconColor: .white,
                       isEnabled: true) { }
            IconButton(iconName: "gamecontroller",
                       style: .primary(backgroundColor: .red, outlineColor: .yellow),
                       iconColor: .green,
                       isEnabled: true) { }
            IconButton(iconName: "cloud",
                       style: .secondary,
                       iconColor: .green,
                       isEnabled: true) { }
            IconButton(iconName: "bolt.fill.",
                       style: .secondary,
                       iconColor: .yellow,
                       isEnabled: true,
                       animationEnabled: false) { }
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
    
    func testButtonsDisabled() throws {
        let view = VStack {
            IconButton(iconName: "plus",
                       isEnabled: false) { }
            IconButton(iconName: "minus",
                       style: .primary(backgroundColor: .red),
                       iconColor: .white,
                       isEnabled: false) { }
            IconButton(iconName: "gamecontroller",
                       style: .primary(backgroundColor: .red, outlineColor: .yellow),
                       iconColor: .green,
                       isEnabled: false) { }
            IconButton(iconName: "cloud",
                       style: .secondary,
                       iconColor: .green,
                       isEnabled: false) { }
            IconButton(iconName: "bolt.fill.",
                       style: .secondary,
                       iconColor: .yellow,
                       isEnabled: false,
                       animationEnabled: false) { }
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
