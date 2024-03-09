import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SettingsListItemTests: XCTestCase {
    private let viewStateOne = SettingsListItemViewState(title: "Title",
                                                         iconName: "pencil.tip",
                                                         iconBackgroundColor: .purple)
    private let viewStateTwo = SettingsListItemViewState(title: "Another title",
                                                         iconName: "link",
                                                         iconBackgroundColor: .green,
                                                         link: URL(string: "www.google.com"))
    
    func testScrim() throws {
        let view = VStack(spacing: Layout.size(1)) {
            SettingsListItem(viewState: viewStateOne)
            SettingsListItem(viewState: viewStateTwo)
            Spacer()
        }.padding(.horizontal)
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
