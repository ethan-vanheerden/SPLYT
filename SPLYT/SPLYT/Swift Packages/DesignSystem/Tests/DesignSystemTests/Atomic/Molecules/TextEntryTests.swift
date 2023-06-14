import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TextEntryTests: XCTestCase {
    private let viewStateOne = TextEntryViewState(placeholder: "Placeholder text")
    private let viewStateTwo = TextEntryViewState(placeholder: "No cancel button",
                                                  includeCancelButton: false)
    private let viewStateThree = TextEntryViewState(placeholder: "Search...",
                                                    iconName: "magnifyingglass")
    
    func testHomeFABRow() throws {
        let view = VStack {
            Spacer()
            TextEntry(text:.constant(""), viewState: viewStateOne)
            TextEntry(text: .constant("Text"), viewState: viewStateTwo)
            TextEntry(text: .constant(""), viewState: viewStateThree)
            Spacer()
        }
            .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
