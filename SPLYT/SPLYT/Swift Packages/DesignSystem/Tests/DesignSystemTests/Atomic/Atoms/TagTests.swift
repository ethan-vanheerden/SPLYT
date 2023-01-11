import XCTest
import DesignSystem
import SwiftUI
@testable import SnapshotTesting

final class TagTests: XCTestCase {
    // TODO: Bug with Xcode and iOS, add snapshot once we can
    func testTag() throws {
        let view = VStack(spacing: Layout.size(1)) {
            Spacer()
            Tag(text: "DROP SET", fill: Color.splytColor(.red))
            Tag(text: "REST PAUSE", fill: Color.splytColor(.green))
            Tag(text: "ECCENTRIC", fill: Color.splytColor(.yellow))
            Tag(text: "UNICORN VOMIT", fill: AngularGradient(colors: [.red, .green, .blue, .purple, .pink],
                                                             center: .center,
                                                             startAngle: .degrees(90),
                                                             endAngle: .degrees(360)))
            Spacer()
        }
        .padding(.horizontal)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .smallImage()), record: true)
    }
}
