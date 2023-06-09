import XCTest
@testable import ExerciseCore

final class RepsOnlyInputTests: XCTestCase {
    func testHasValue() {
        let inputValue = RepsOnlyInput(reps: 10)
        let inputNoValue = RepsOnlyInput(placeholder: 10)
        
        XCTAssertTrue(inputValue.hasValue)
        XCTAssertFalse(inputNoValue.hasValue)
    }
    
    func testHasPlaceholder() {
        let inputPlaceholder = RepsOnlyInput(reps: 5, placeholder: 5)
        let inputNoPlaceholder = RepsOnlyInput()
        
        XCTAssertTrue(inputPlaceholder.hasPlaceholder)
        XCTAssertFalse(inputNoPlaceholder.hasPlaceholder)
    }
}
