import XCTest
@testable import ExerciseCore

final class SetInputTests: XCTestCase {
    func testUpdateSetInput_RepsWeight() {
        let old = SetInput.repsWeight(reps: 5, weight: nil)
        
        XCTAssertEqual(old.updateSetInput(with: .repsOnly(reps: 5)), old)
        XCTAssertEqual(old.updateSetInput(with: .time(seconds: 30)), old)
        XCTAssertEqual(old.updateSetInput(with: .repsWeight(reps: 8, weight: 100)),
                       .repsWeight(reps: 8, weight: 100))
    }
    
    func testUpdateSetInput_RepsOnly() {
        let old = SetInput.repsOnly(reps: nil)
        
        XCTAssertEqual(old.updateSetInput(with: .repsOnly(reps: 5)),
                       .repsOnly(reps: 5))
        XCTAssertEqual(old.updateSetInput(with: .time(seconds: 30)), old)
        XCTAssertEqual(old.updateSetInput(with: .repsWeight(reps: 8, weight: 100)), old)
    }
    
    func testUpdateSetInput_Time() {
        let old = SetInput.time(seconds: 60)
        
        XCTAssertEqual(old.updateSetInput(with: .repsOnly(reps: 5)), old)
        XCTAssertEqual(old.updateSetInput(with: .time(seconds: 30)), .time(seconds: 30))
        XCTAssertEqual(old.updateSetInput(with: .repsWeight(reps: 8, weight: 100)), old)
    }
}
