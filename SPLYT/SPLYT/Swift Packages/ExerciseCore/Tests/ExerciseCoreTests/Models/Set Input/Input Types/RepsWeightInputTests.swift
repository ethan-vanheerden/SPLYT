import XCTest
@testable import ExerciseCore

final class RepsWeightInputTests: XCTestCase {
    func testHasValue() {
        let inputValueReps = RepsWeightInput(reps: 5, repsPlaceholder: 10)
        let inputValueWeight = RepsWeightInput(weight: 8, repsPlaceholder: 5)
        let inputNoValue = RepsWeightInput()
        
        XCTAssertTrue(inputValueReps.hasValue)
        XCTAssertTrue(inputValueWeight.hasValue)
        XCTAssertFalse(inputNoValue.hasValue)
    }
    
    func testHasPlaceholder() {
        let inputPlaceholderReps = RepsWeightInput(reps: 5, repsPlaceholder: 10)
        let inputPlaceholderWeight = RepsWeightInput(weightPlaceholder: 135)
        let inputNoPlaceholder = RepsWeightInput(weight: 100)
        
        XCTAssertTrue(inputPlaceholderReps.hasPlaceholder)
        XCTAssertTrue(inputPlaceholderWeight.hasPlaceholder)
        XCTAssertFalse(inputNoPlaceholder.hasPlaceholder)
    }
}
