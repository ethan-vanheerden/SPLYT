import XCTest
@testable import DesignSystem

final class InputTypeTests: XCTestCase {
    
    func testKeyboardType() {
        XCTAssertEqual(KeyboardInputType.reps.keyboardType, .numberPad)
        XCTAssertEqual(KeyboardInputType.weight.keyboardType, .decimalPad)
        XCTAssertEqual(KeyboardInputType.time.keyboardType, .numberPad)
    }
}
