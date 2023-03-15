import XCTest
import SnapshotTesting
import SwiftUI
import DesignSystem

final class TextFontTests: XCTestCase {
    func testText() {
        let view = HStack {
            VStack {
                ForEach(SplytFont.allCases, id: \.self) { style in
                    Text("Large Title")
                        .largeTitle(style: style)
                    Text("Title 1")
                        .title1(style: style)
                    Text("Title 2")
                        .title2(style: style)
                }
            }
            VStack {
                ForEach(SplytFont.allCases, id: \.self) { style in
                    Text("Title 3")
                        .title3(style: style)
                    Text("Body")
                        .body(style: style)
                    Text("Subheading")
                        .subhead(style: style)
                    Text("Footnote")
                        .footnote(style: style)
                }
            }
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(matching: vc, as: .image(on: .largeImage()))
    }
}
