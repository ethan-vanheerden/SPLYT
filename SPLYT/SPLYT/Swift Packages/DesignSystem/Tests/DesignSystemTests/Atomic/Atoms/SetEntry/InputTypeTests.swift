import XCTest
@testable import DesignSystem

final class InputTypeTests: XCTestCase {
    func testGetString_Reps() {
        XCTAssertEqual(InputType.reps(nil).getString, "")
        XCTAssertEqual(InputType.reps(8).getString, "8")
    }
    
    func testGetString_Weight() {
        XCTAssertEqual(InputType.weight(nil).getString, "")
        XCTAssertEqual(InputType.weight(8).getString, "8")
        XCTAssertEqual(InputType.weight(8.5).getString, "8.5")
        XCTAssertEqual(InputType.weight(8.0).getString, "8")
    }
    
    func testGetString_Time() {
        XCTAssertEqual(InputType.time(nil).getString, "")
        XCTAssertEqual(InputType.time(30).getString, "30")
    }
}
