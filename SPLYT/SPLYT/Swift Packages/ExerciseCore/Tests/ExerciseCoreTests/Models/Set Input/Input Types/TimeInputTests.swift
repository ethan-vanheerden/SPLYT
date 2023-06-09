import XCTest
@testable import ExerciseCore

final class TimeInputTests: XCTestCase {
    func testHasValue() {
        let inputValue = TimeInput(seconds: 10)
        let inputNoValue = TimeInput(placeholder: 10)
        
        XCTAssertTrue(inputValue.hasValue)
        XCTAssertFalse(inputNoValue.hasValue)
    }
    
    func testHasPlaceholder() {
        let inputPlaceholder = TimeInput(seconds: 5, placeholder: 5)
        let inputNoPlaceholder = TimeInput()
        
        XCTAssertTrue(inputPlaceholder.hasPlaceholder)
        XCTAssertFalse(inputNoPlaceholder.hasPlaceholder)
    }
}
