import XCTest
@testable import DesignSystem

final class TagCounterTests: XCTestCase {
    private let sut = TagCounter.shared
    
    override func setUp() async throws {
        sut.resetCount()
    }
    
    func testGetTag() {
        XCTAssertEqual(sut.getTag(), 1)
        XCTAssertEqual(sut.getTag(), 2)
        XCTAssertEqual(sut.getTag(), 3)
    }
}
