import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class EmojiTitleTests: XCTestCase {
    func testEmojiTitle() throws {
        let view = VStack {
            EmojiTitle(emoji: "😁", title: "This is a title")
            EmojiTitle(emoji: "🫨", title: "This is another title")
                .foregroundColor(Color(splytColor: .lightBlue))
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()))
    }
}
