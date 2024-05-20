import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class SettingsListItemTests: XCTestCase {
    private let viewStateOne = SettingsListItemViewState(title: "Title",
                                                         iconName: "pencil.tip",
                                                         iconBackgroundColor: .darkBlue)
    private let viewStateTwo = SettingsListItemViewState(title: "Another title",
                                                         iconName: "link",
                                                         iconBackgroundColor: .green,
                                                         link: URL(string: "www.google.com"))
    
    func testSettingsListItem() throws {
        let view = VStack(spacing: Layout.size(1)) {
            SettingsListItem(viewState: viewStateOne)
            SettingsListItem(viewState: viewStateTwo)
            Spacer()
        }.padding()
        
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
